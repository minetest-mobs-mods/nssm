local creative_mode = minetest.settings:get_bool("creative_mode")

local function is_walkable(node_name)
    if not minetest.registered_nodes[node_name] then
        return true -- non-existent, we should stop the spear !
    end
    if minetest.registered_nodes[node_name].walkable == true
      or minetest.registered_nodes[node_name].walkable == nil
        then
        return true
    end
    return false
end

local function spears_shot(itemstack, player)
    local spear = itemstack:get_name() .. '_entity'

    if spear == "nssm:spear_of_peace_entity" then
        speed = 32
        gravity = 9.8
    else
        speed = 16
        gravity = 9.8
    end
    local drag = .3

    local playerpos = player:getpos()
    local obj = minetest.add_entity({x=playerpos.x,y=playerpos.y+1.5,z=playerpos.z}, spear)
    local dir = player:get_look_dir()

    obj:setvelocity({x=dir.x*speed, y=dir.y*speed, z=dir.z*speed})
    obj:setacceleration({x=-dir.x*drag, y=-gravity, z=-dir.z*drag})
    obj:setyaw(player:get_look_yaw()+math.pi)
    minetest.sound_play("spears_sound", {pos=playerpos})
    obj:get_luaentity().wear = itemstack:get_wear()
    obj:get_luaentity().shooter = player
    return true
end


local function spears_set_entity(kind, eq, toughness, breadth)
    local spearname = "nssm:spear_"..kind
    local spearentityname = spearname.."_entity"
    local maxwear = 65535
    local weardown = maxwear/toughness

    breadth = breadth or 1

    local SPEAR_ENTITY = {
        physical = false,
        timer = 0,
        visual = "wielditem",
        visual_size = {x=0.15, y=0.1},
        textures = {spearname},
        lastpos = {},
        collisionbox = {0,0,0,0,0,0},

        on_punch = function(self, puncher)
            -- pick up item
            if puncher then
                if puncher:is_player() then
                    local stack = {name=spearname, wear=self.wear}
                    local inv = puncher:get_inventory()
                    if inv:room_for_item("main", stack) then
                        inv:add_item("main", stack)
                        self.object:remove()
                    end
                end
            end
        end,
    }
    
    SPEAR_ENTITY.on_step = function(self, dtime)
        self.timer = self.timer+dtime

        local pos = self.object:getpos()
        local node = minetest.get_node(pos)

        if not self.wear then
            self.object:remove()
            return
        end

        -- pos exists --> entity has moved at least once
        if self.lastpos.x then
            if node.name ~= "air" -- not air, walkable
              and is_walkable(node.name)
              then

                self.object:remove()
                local halfweardown = weardown/2
                if self.wear+halfweardown < maxwear then
                    minetest.add_item(self.lastpos, {name=spearname, wear=self.wear+halfweardown})
                end

            -- air or non-walkable
            else
                local objs = minetest.get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 1.5*breadth)
                local add_at
                for k, obj in pairs(objs) do
                    if obj:get_luaentity() ~= nil then
                        if obj:get_luaentity().name ~= spearentityname and obj:get_luaentity().name ~= "__builtin:item" then
                            if not (obj:is_player() and obj:get_luaentity().shooter:get_player_name() == obj:get_player_name() ) then
                                local speed = vector.length(self.object:getvelocity())
                                local damage = (speed + eq)^1.12-20

                                obj:punch(self.object, 1.0, {
                                    full_punch_interval=1.0,
                                    damage_groups={fleshy=damage},
                                }, nil)

                                self.object:remove()

                                -- Wear down for each mob hit
                                if self.wear+weardown < maxwear then
                                    self.wear = self.wear+weardown
                                    add_at = {pos = self.lastpos, def={name=spearname, wear=self.wear}}
                                end
                            end
                        end
                    end
                end

                if add_at then
                    minetest.add_item(add_at.pos, add_at.def)
                end
            end
        end
        
        self.lastpos={x=pos.x, y=pos.y, z=pos.z}
    end -- entity step definition


    return SPEAR_ENTITY
end

--Tools

function spears_register_spear(kind, desc, eq, toughness, material, scale)
    scale = scale or 1

    minetest.register_tool("nssm:spear_" .. kind, {
        description = desc .. " Spear",
        wield_image = "spear_" .. kind .. ".png",
        inventory_image = "spear_" .. kind .. ".png^[transform4",
        wield_scale= {x=2*scale, y=1*scale, z=1*scale},
        on_drop = function(itemstack, user, pointed_thing)
            spears_shot(itemstack, user)
            if not creative_mode then
                itemstack:take_item()
            end
            return itemstack
        end,
        on_place = function(itemstack, user, pointed_thing)
            minetest.add_item(pointed_thing.above, itemstack)
            if not creative_mode then
                itemstack:take_item()
            end
            return itemstack
        end,
        tool_capabilities = {
            full_punch_interval = 1.3,
            max_drop_level=1,
            groupcaps={
                snappy = {times={[3]=0.2, [2]=0.2, [1]=0.2}, uses=toughness, maxlevel=1},
            },
            damage_groups = {fleshy=eq},
        }
    })
    
    local SPEAR_ENTITY=spears_set_entity(kind, eq, toughness, scale)
    
    minetest.register_entity("nssm:spear_" .. kind .. "_entity", SPEAR_ENTITY)
    
    minetest.register_craft({
        output = 'nssm:spear_' .. kind,
        recipe = {
            {'group:wood', 'group:wood', material},
        }
    })
    
    minetest.register_craft({
        output = 'nssm:spear_' .. kind,
        recipe = {
            {material, 'group:wood', 'group:wood'},
        }
    })
end


spears_register_spear('ant', 'Ant', 6, 25, 'nssm:ant_mandible')

spears_register_spear('mantis', 'Mantis', 6, 10, 'nssm:mantis_claw')

spears_register_spear('manticore', 'Manticore', 8, 8, 'nssm:manticore_spine')

spears_register_spear('ice_tooth', 'Ice Tooth', 16, 200, 'nssm:ice_tooth')

spears_register_spear('little_ice_tooth', 'Little Ice Tooth', 7, 10, 'nssm:little_ice_tooth')

spears_register_spear('duck_beak', 'Duck Beak', 5, 6, 'nssm:duck_beak')

spears_register_spear('felucco_horn', 'Felucco Horn', 7, 9, 'nssm:felucco_horn')

spears_register_spear('of_peace', 'Grand Peace', 30, 300, 'nssm:wrathful_moranga', 2)
