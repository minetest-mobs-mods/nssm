-- Moranga-based tools
-- These can only be crafted with NSSB loaded

if minetest.get_modpath("nssb") then

    minetest.register_craft({
        output = 'nssm:axe_of_pride',
        recipe = {
            {'nssm:proud_moranga', 'nssm:proud_moranga', 'nssm:proud_moranga'},
            {'nssm:proud_moranga', 'nssb:moranga_ingot', ''},
            {'', 'nssb:moranga_ingot', ''},
        }
    })

    -- FIXME change gratuitousness to wrath
    minetest.register_craft({
        output = 'nssm:gratuitousness_battleaxe',
        recipe = {
            {'nssm:greedy_moranga', 'nssm:greedy_moranga', 'nssm:greedy_moranga'},
            {'nssm:greedy_moranga', 'nssb:moranga_ingot', 'nssm:greedy_moranga'},
            {'', 'nssb:moranga_ingot', ''},
        }
    })

    minetest.register_craft({
        output = 'nssm:sword_of_envy',
        recipe = {
            {'nssm:envious_moranga'},
            {'nssm:envious_moranga'},
            {'nssb:moranga_ingot'},
        }
    })

    -- FIXME should be greed?
    minetest.register_craft({
        output = 'nssm:sword_of_eagerness',
        recipe = {
            {'nssm:slothful_moranga'},
            {'nssm:slothful_moranga'},
            {'nssb:moranga_ingot'},
        }
    })

    -- FIXME should be laziness
    minetest.register_craft({
        output = 'nssm:falchion_of_eagerness',
        recipe = {
            {'nssm:slothful_moranga','nssm:slothful_moranga'},
            {'nssm:slothful_moranga', ''},
            {'nssb:moranga_ingot',''},
        }
    })

    minetest.register_craft({
        output = 'nssm:sword_of_gluttony',
        recipe = {
            {'nssm:gluttonous_moranga', 'nssm:gluttonous_moranga', 'nssm:gluttonous_moranga'},
            {'', 'nssm:gluttonous_moranga', ''},
            {'', 'nssb:moranga_ingot', ''},
        }
    })

    function nssm_register_moranga (vice)
        minetest.register_craft({
            output = 'nssm:'.. vice ..'_moranga',
            recipe = {
                {'nssm:'.. vice ..'_soul_fragment', 'nssb:moranga_ingot', 'nssm:'.. vice ..'_soul_fragment'},
                {'nssb:moranga_ingot', 'nssm:'.. vice ..'_soul_fragment', 'nssb:moranga_ingot'},
                {'nssm:'.. vice ..'_soul_fragment', 'nssb:moranga_ingot', 'nssm:'.. vice ..'_soul_fragment'},
            }
        })
    end

    nssm_register_moranga ("lustful")
    nssm_register_moranga ("greedy")
    nssm_register_moranga ("slothful")
    nssm_register_moranga ("wrathful")
    nssm_register_moranga ("gluttonous")
    nssm_register_moranga ("envious")
    nssm_register_moranga ("proud")
end

-- Tools with special drop routines

local function find_dropfuel(player, dropfuel_def)
    -- return itemstack index, and stack itself, with qtty removed
    -- or none if not found/not enough found
    local i
    local pname = player:get_player_name()
    local player_inv = minetest.get_inventory({type='player', name = pname})
    local total_count = 0
    local qtty = dropfuel_def.quantity or 1

    for i = 1,32 do
        local itemstack = player_inv:get_stack('main', i)
        local itemname = itemstack:get_name()
        if itemname == dropfuel_def.name then
            if itemstack:get_count() >= qtty then
                return true
            else
                total_count = total_count + itemstack:get_count()

                if total_count >= (qtty) then
                    return true
                end
            end
        end
    end

    minetest.chat_send_player(pname, "You do not have enough "..dropfuel_def.description)
    return false
end

local function eat_dropfuel(player, dropfuel_def)
    local i
    local pname = player:get_player_name()
    local player_inv = minetest.get_inventory({type='player', name = pname})
    local total_count = 0
    local qtty = dropfuel_def.quantity or 1

    -- TODO combine find_dropfuel and eat_dropfuel so that we're
    --    not scouring the inventory twice...
    if find_dropfuel(player, dropfuel_def) then
        for i = 1,32 do
            local itemstack = player_inv:get_stack('main', i)
            local itemname = itemstack:get_name()
            if itemname == dropfuel_def.name then
                if itemstack:get_count() >= qtty then
                    itemstack:take_item(qtty)
                    player_inv:set_stack('main', i, itemstack)
                    return true
                else
                    total_count = total_count + itemstack:get_count()
                    itemstack:clear()
                    player_inv:set_stack('main', i, itemstack)

                    if total_count >= (qtty) then
                        return true
                    end
                end
            end
        end
    end

    return false
end

minetest.register_tool("nssm:axe_of_pride", {
    -- Damage enemy, heal user by the same amount
    description = "Axe of Pride",
    inventory_image = "axe_of_pride.png",
    wield_scale= {x=2,y=2,z=1.5},
    tool_capabilities = {
        full_punch_interval =1.3 ,
        max_drop_level=1,
        groupcaps={
            choppy={times={[1]=0.6, [2]=0.5, [3]=0.4}, uses=100, maxlevel=1},
            fleshy={times={[2]=0.8, [3]=0.4}, uses=400, maxlevel=1}
        },
        damage_groups = {fleshy=16},
    },
    on_drop = function(itemstack, dropper, pos)
        local objects = minetest.env:get_objects_inside_radius(pos, 10)
        local dropfuel = {name="nssm:energy_globe", description="energy sphere", quantity=1}
        local part = 0

        for _,obj in ipairs(objects) do
            part = 0

            local pname = dropper:get_player_name()
            local player_inv = minetest.get_inventory({type='player', name = pname})

            if not find_dropfuel(dropper, dropfuel) then
                return
            else
                if obj:is_player() then
                    if (obj:get_player_name() ~= dropper:get_player_name()) then
                        obj:set_hp(obj:get_hp()-10)
                        dropper:set_hp(dropper:get_hp()+10)

                        eat_dropfuel(dropper, dropfuel)
                        part = 1
                    end
                else
                    if (obj:get_luaentity().health) then
                        --minetest.chat_send_all("Entity")
                        obj:get_luaentity().health = obj:get_luaentity().health -10

                        if obj:get_luaentity().check_for_death then
                            obj:get_luaentity():check_for_death({type = "punch"})
                        end

                        dropper:set_hp(dropper:get_hp()+10)

                        eat_dropfuel(dropper, dropfuel)
                        part = 1
                    end
                end

                if part == 1 then
                    local s = dropper:getpos()
                    local p = obj:getpos()
                    local m = 2

                    minetest.add_particlespawner({
                        amount = 3,
                        time = 0.1,
                        minpos = {x=p.x-0.5, y=p.y-0.5, z=p.z-0.5},
                        maxpos = {x=p.x+0.5, y=p.y+0.5, z=p.z+0.5},
                        minvel = {x=(s.x-p.x)*m, y=(s.y-p.y)*m, z=(s.z-p.z)*m},
                        maxvel = {x=(s.x-p.x)*m, y=(s.y-p.y)*m, z=(s.z-p.z)*m},
                        minacc = {x=s.x-p.x, y=s.y-p.y, z=s.z-p.z},
                        maxacc = {x=s.x-p.x, y=s.y-p.y, z=s.z-p.z},
                        minexptime = 0.5,
                        maxexptime = 1,
                        minsize = 3,
                        maxsize = 4,
                        collisiondetection = false,
                        texture = "heart.png"
                    })
                end
            end
        end
    end,
})

minetest.register_tool("nssm:gratuitousness_battleaxe", {
    -- aka Battleaxe of Boom - causes and explosion at <epicenter_distance> nodes from player
    description = "Gratuitousness Battleaxe",
    inventory_image = "gratuitousness_battleaxe.png",
    wield_scale= {x=2.2,y=2.2,z=1.5},
    tool_capabilities = {
        full_punch_interval =1.6 ,
        max_drop_level=1,
        groupcaps={
            snappy={times={[1]=0.6, [2]=0.5, [3]=0.4}, uses=100, maxlevel=1},
            fleshy={times={[2]=0.8, [3]=0.4}, uses=400, maxlevel=1}
        },
        damage_groups = {fleshy=18},
    },
    on_drop = function(itemstack, dropper, pos)
        local epicenter_distance = 10
        local objects = minetest.env:get_objects_inside_radius(pos, 10)
        local flag = 0
        local vec = dropper:get_look_dir()
        local pos = dropper:getpos()
        --vec.y = 0
        local dropfuel = {name = "nssm:energy_globe", description = "energy globe", quantity = 1}

        for i=1,epicenter_distance do
            pos = vector.add(pos, vec)
        end

        local pname = dropper:get_player_name()
        local player_inv = minetest.get_inventory({type='player', name = pname})

        if not find_dropfuel(dropper, dropfuel) then
            return
        else
            eat_dropfuel(dropper, dropfuel)
            tnt.boom(pos, {damage_radius=5,radius=4,ignore_protection=false})
        end
    end,
})

minetest.register_tool("nssm:sword_of_eagerness", {
    -- Cause enemies to be sent upwards y+20
    description = "Sword of Eagerness",
    inventory_image = "sword_of_eagerness.png",
    wield_scale= {x=2,y=2,z=1},
    tool_capabilities = {
        full_punch_interval =0.7 ,
        max_drop_level=1,
        groupcaps={
            snappy={times={[1]=0.6, [2]=0.5, [3]=0.4}, uses=100, maxlevel=1},
            fleshy={times={[2]=0.8, [3]=0.4}, uses=400, maxlevel=1}
        },
        damage_groups = {fleshy=14},
    },
    on_drop = function(itemstack, dropper, pos)
        local objects = minetest.env:get_objects_inside_radius(pos, 10)
        local flag = 0
        local dropfuel = {name = "nssm:energy_globe", description = "energy globe", quantity = 1}

        for _,obj in ipairs(objects) do
            local part = 0
            if flag == 0 then
                local pname = dropper:get_player_name()
                local player_inv = minetest.get_inventory({type='player', name = pname})

                if not find_dropfuel(dropper, dropfuel) then
                    return
                else
                    local pos = obj:getpos()
                    pos.y = pos.y + 15
                    if (obj:is_player()) then
                        if (obj:get_player_name()~=dropper:get_player_name()) then
                            part=1
                            obj:setpos(pos)
                            --flag = 1

                            eat_dropfuel(dropper, dropfuel)
                        end
                    else
                        if (obj:get_luaentity().health) then
                            obj:get_luaentity().old_y = pos.y
                            obj:setpos(pos)
                            part=1
                            --flag = 1

                            eat_dropfuel(dropper, dropfuel)
                        end
                    end
                    if part==1 then
                        local s = pos
                        s.y = s.y - 15
                        minetest.add_particlespawner({
                            amount = 25,
                            time = 0.3,
                            minpos = vector.subtract(s, 0.5),
                            maxpos = vector.add(s, 0.5),
                            minvel = {x=0, y=10, z=0},
                            maxvel = {x=0.1, y=11, z=0.1},
                            minacc = {x=0,y=1,z=0},
                            maxacc = {x=0,y=1,z=0},
                            minexptime = 0.5,
                            maxexptime = 1,
                            minsize = 1,
                            maxsize = 2,
                            collisiondetection = false,
                            texture = "slothful_soul_fragment.png"
                        })
                    end
                end
            end
        end
    end,
})

minetest.register_tool("nssm:falchion_of_eagerness", {
    -- Sends player 16m in the direction in which they are pointing...
    description = "Falchion of Eagerness",
    inventory_image = "falchion_of_eagerness.png",
    wield_scale= {x=2,y=2,z=1},
    tool_capabilities = {
        full_punch_interval =1 ,
        max_drop_level=1,
        groupcaps={
            snappy={times={[1]=0.6, [2]=0.5, [3]=0.4}, uses=100, maxlevel=1},
            fleshy={times={[2]=0.8, [3]=0.4}, uses=400, maxlevel=1}
        },
        damage_groups = {fleshy=16},
    },
    on_drop = function(itemstack, dropper, pos)
        local vec = dropper:get_look_dir()
        local pos_destination = dropper:getpos()
        --vec.y = 0
        local dropfuel = {name = "nssm:life_energy", description = "life energy", quantity = 5}

        for i=1,16 do
            pos_destination = vector.add(pos_destination, vec)
        end

        local pname = dropper:get_player_name()
        local player_inv = minetest.get_inventory({type='player', name = pname})

        if player_inv:is_empty('main') then
            --minetest.chat_send_all("Inventory empty")
        else
            if find_dropfuel(dropper, dropfuel) then
                return

            elseif minetest.is_protected(pos_destination, pname) or nssm.unswappable_node(pos_destination) then
                minetest.chat_send_player(pname, "You cannot go to that protected space!")
                return

            else
                local pos_particles = dropper:getpos()
                minetest.add_particlespawner({
                    amount = 25,
                    time = 0.3,
                    minpos = vector.subtract(pos_particles, 0.5),
                    maxpos = vector.add(pos_particles, 0.5),
                    minvel = {x=0, y=10, z=0},
                    maxvel = {x=0.1, y=11, z=0.1},
                    minacc = {x=0,y=1,z=0},
                    maxacc = {x=0,y=1,z=0},
                    minexptime = 0.5,
                    maxexptime = 1,
                    minsize = 1,
                    maxsize = 2,
                    collisiondetection = false,
                    texture = "slothful_soul_fragment.png"
                })

                local dy, digpos
                for dy = -1,1 do
                    digpos = pos_destination + dy
                    if not nssm.unswappable_node(digpos) then
                        minetest.remove_node(digpos)
                    end
                end

                dropper:setpos(pos_destination)

                pos_particles = pos_destination
                pos_particles.y = pos_particles.y+10
                minetest.add_particlespawner({
                    25, --amount
                    0.3, --time
                    vector.subtract(pos_particles, 0.5), --minpos
                    vector.add(pos_particles, 0.5), --maxpos
                    {x=0, y=-10, z=0}, --minvel
                    {x=0.1, y=-11, z=0.1}, --maxvel
                    {x=0,y=-1,z=0}, --minacc
                    {x=0,y=-1,z=0}, --maxacc
                    0.5, --minexptime
                    1, --maxexptime
                    1, --minsize
                    2, --maxsize
                    false, --collisiondetection
                    "slothful_soul_fragment.png" --texture
                })

                eat_dropfuel(dropper, dropfuel)
            end
        end
    end,
})

minetest.register_tool("nssm:sword_of_envy", {
    -- Switch the health of the enemy with the health of the player
    -- Particularly useful when enemy's health is way over 20 -- this is pretty much a cheat item when facing a boss...
    description = "Sword of Envy",
    inventory_image = "sword_of_envy.png",
    wield_scale= {x=2,y=2,z=1},
    tool_capabilities = {
        full_punch_interval =0.9 ,
        max_drop_level=1,
        groupcaps={
            snappy={times={[1]=0.6, [2]=0.5, [3]=0.4}, uses=100, maxlevel=1},
            fleshy={times={[2]=0.5, [3]=0.2}, uses=400, maxlevel=1}
        },
        damage_groups = {fleshy=14},
    },
    on_drop = function(itemstack, dropper, pos)
        local objects = minetest.env:get_objects_inside_radius(pos, 10)
        local flag = 0
        local dropfuel = {name = "nssm:energy_globe", description = "energy globe", quantity = 1}

        for _,obj in ipairs(objects) do
            if flag == 0 then
                local pname = dropper:get_player_name()
                local player_inv = minetest.get_inventory({type='player', name = pname})

                if player_inv:is_empty('main') then
                    --minetest.chat_send_all("Inventory empty")
                else
                    if not find_dropfuel(dropper, dropfuel) then
                        return
                    else
                        if (obj:is_player()) then
                            --minetest.chat_send_all("Giocatore")
                            if (obj:get_player_name()~=dropper:get_player_name()) then
                                local hpp = obj:get_hp()
                                obj:set_hp(dropper:get_hp())
                                dropper:set_hp(hpp)
                                flag = 1

                                eat_dropfuel(dropper, dropfuel)
                            end
                        else
                            if (obj:get_luaentity().health) then
                                local obj_health = obj:get_luaentity().health
                                obj:get_luaentity().health = dropper:get_hp()

                                if obj_health > 20 then
                                    dropper:set_hp(20)
                                else
                                    dropper:set_hp(obj_health)
                                end

                                if obj:get_luaentity().check_for_death then
                                    obj:get_luaentity():check_for_death({type = "punch"})
                                end
                                flag = 1

                                eat_dropfuel(dropper, dropfuel)
                            end
                        end
                    end
                end
            end
        end
    end,
})

minetest.register_tool("nssm:sword_of_gluttony", {
    -- Kills nearby monsters and causes them to drop roasted duck legs! :D
    description = "Sword of Gluttony",
    inventory_image = "sword_of_gluttony.png",
    wield_scale= {x=2,y=2,z=1},
    tool_capabilities = {
        full_punch_interval =1 ,
        max_drop_level=1,
        groupcaps={
            snappy={times={[1]=0.9, [2]=0.7, [3]=0.4}, uses=100, maxlevel=1},
            fleshy={times={[2]=0.6, [3]=0.2}, uses=400, maxlevel=1}
        },
        damage_groups = {fleshy=14},
    },
    on_drop = function(itemstack, dropper, pos)
        local objects = minetest.env:get_objects_inside_radius(pos, 10)
        local flag = 0
        local dropfuel = {name = "nssm:energy_globe", description = "energy globe", quantity = 1}

        for _,obj in ipairs(objects) do
            if flag == 0 then
                local pname = dropper:get_player_name()
                local player_inv = minetest.get_inventory({type='player', name = pname})

                if player_inv:is_empty('main') then
                    --minetest.chat_send_all("Inventory empty")
                else
                    if not find_dropfuel(dropper, dropfuel) then
                        return
                    else
                        if (obj:is_player()) then
                            if (obj:get_player_name()~=dropper:get_player_name()) then
                                obj:set_hp(obj:get_hp()-10)
                                --flag = 1

                                eat_dropfuel(dropper, dropfuel)
                            end
                        else
                            if (obj:get_luaentity().health) then
                                if obj:get_luaentity().health <= 32 then
                                    local pos = obj:getpos()
                                    obj:remove()

                                    -- We don't use check_for_death, as that would cause it to put regular drops
                                    --  (FIXME - this means hydra hobs do not respawn...)
                                    --check_for_death(obj:get_luaentity())
                                    --flag = 1

                                    eat_dropfuel(dropper, dropfuel)

                                    for i = 1,math.random(1,4) do
                                        drop = minetest.add_item(pos, "nssm:roasted_duck_legs 1")
                                        nssm.drops(drop)
                                    end

                                    local s = obj:getpos()
                                    local p = dropper:getpos()
                                    local m = 3

                                    minetest.add_particlespawner({
                                        amount = 10,
                                        time = 0.1,
                                        minpos = {x=p.x-0.5, y=p.y-0.5, z=p.z-0.5},
                                        maxpos = {x=p.x+0.5, y=p.y+0.5, z=p.z+0.5},
                                        minvel = {x=(s.x-p.x)*m, y=(s.y-p.y)*m, z=(s.z-p.z)*m},
                                        maxvel = {x=(s.x-p.x)*m, y=(s.y-p.y)*m, z=(s.z-p.z)*m},
                                        minacc = {x=s.x-p.x, y=s.y-p.y, z=s.z-p.z},
                                        maxacc = {x=s.x-p.x, y=s.y-p.y, z=s.z-p.z},
                                        minexptime = 0.5,
                                        maxexptime = 1,
                                        minsize = 1,
                                        maxsize = 2,
                                        collisiondetection = false,
                                        texture = "gluttonous_soul_fragment.png"
                                    })
                                end
                            end
                        end
                    end
                end
            end
        end
    end,
})

minetest.register_tool("nssm:death_scythe", {
    -- Kills everything around it, consumes user's life
    -- Casues dry grass, dry shrubs, and dead leaves, dropping lots of life eergy to drop too
    description = "Death Scythe",
    wield_scale= {x=3,y=3,z=1.3},
    inventory_image = "death_scythe.png",
    tool_capabilities = {
        full_punch_interval =0.2 ,
        max_drop_level=1,
        groupcaps={
            snappy={times={[1]=0.1, [2]=0.1, [3]=0.1}, uses=28000, maxlevel=1},
            fleshy={times={[2]=0.1, [3]=0.1}, uses=28000, maxlevel=1}
        },
        damage_groups = {fleshy=28},
    },
    groups ={not_in_creative_inventory=1},
    on_drop = function(itemstack, dropper, pos)
        local objects = minetest.env:get_objects_inside_radius(pos, 10)
        local flag = 0

        dropper:set_hp(math.ceil(dropper:get_hp()/2) )

        for _,obj in ipairs(objects) do
            flag = 0
            if (obj:is_player()) then
                if (obj:get_player_name() ~= dropper:get_player_name()) then
                    obj:set_hp(obj:get_hp()-40)
                    flag = 1
                end
            else
                if (obj:get_luaentity().health) then
                    obj:get_luaentity().health = obj:get_luaentity().health -40
                    if obj:get_luaentity().check_for_death then
                        obj:get_luaentity():check_for_death({type = "punch"})
                    end
                    flag = 1
                end
            end
            if flag == 1 then
                for i = 1,math.random(1,2) do
                    drop = minetest.add_item(pos, "nssm:energy_globe 1")

                    if drop then
                        drop:setvelocity({
                            x = math.random(-10, 10) / 9,
                            y = 5,
                            z = math.random(-10, 10) / 9,
                        })
                    end
                end
            end
        end
        local pos = dropper:getpos()
        local vec = {x=5,y=5,z=5}
        local poslist = minetest.find_nodes_in_area(vector.subtract(pos, vec), vector.add(pos,vec), "default:dirt_with_grass")
        for _,v in pairs(poslist) do
            --minetest.chat_send_all(minetest.pos_to_string(v))
            minetest.set_node(v, {name="default:dirt_with_dry_grass"})
            if math.random(1,3)==1 then
                v.y = v.y +2
                drop = minetest.add_item(v, "nssm:life_energy 1")
                nssm.drops(drop)
            end
        end

        local poslist = minetest.find_nodes_in_area_under_air(vector.subtract(pos, vec), vector.add(pos,vec), "group:flora")
        for _,v in pairs(poslist) do
            --minetest.chat_send_all(minetest.pos_to_string(v))
            minetest.set_node(v, {name="default:dry_shrub"})
            if math.random(1,3)==1 then
                v.y = v.y +2
                drop = minetest.add_item(v, "nssm:life_energy 1")
                nssm.drops(drop)
            end
        end

        local poslist = minetest.find_nodes_in_area(vector.subtract(pos, vec), vector.add(pos,vec), "group:leaves")
        for _,v in pairs(poslist) do
            --minetest.chat_send_all(minetest.pos_to_string(v))
            minetest.set_node(v, {name="nssm:dead_leaves"})
            if math.random(1,3)==1 then
                v.y = v.y +2
                drop = minetest.add_item(v, "nssm:life_energy 1")
                nssm.drops(drop)
            end
        end
    end,
})

