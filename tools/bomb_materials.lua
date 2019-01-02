function nssm_register_throwitem(name, descr, def)

    minetest.register_craftitem("nssm:"..name.."_bomb", {
        description = descr,
        inventory_image = name.."_bomb.png",
        on_use = function(itemstack, placer, pointed_thing)
            --weapons_shot(itemstack, placer, pointed_thing, def.velocity, name)
            local velocity = 15
            local dir = placer:get_look_dir();
            local playerpos = placer:getpos();
            posthrow = playerpos
            local obj = minetest.env:add_entity({x=playerpos.x+0+dir.x,y=playerpos.y+2+dir.y,z=playerpos.z+0+dir.z}, "nssm:"..name.."_bomb_flying")
            local vec = {x=dir.x*velocity,y=dir.y*velocity,z=dir.z*velocity}
            local acc = {x=0, y=-9.8, z=0}
            obj:setvelocity(vec)
            obj:setacceleration(acc)
            itemstack:take_item()
            return itemstack
        end,
    })

    minetest.register_entity("nssm:"..name.."_bomb_flying",{
        textures = {name.."_bomb.png"},
        hp_max = 20,
        collisionbox = {-0.1,-0.1,-0.1, 0.1,0.1,0.1},
        on_step = function(self, dtime)
            local pos = self.object:getpos()
            local node = minetest.get_node(pos)
            local n = node.name
            if n ~= "air" then
                def.hit_node(self, pos)
                self.object:remove()
            end
        end,
    })
end

nssm_register_throwitem("cobweb", "Cobweb Bomb", {
    hit_node = function(self,pos)
        for dx = -1,1 do
            for dy = -1,1 do
                for dz = -1,1 do
                    local pos1 = {x = pos.x+dx, y=pos.y+dy, z=pos.z+dz}
                    if not minetest.is_protected(pos1, "") or not minetest.get_item_group(minetest.get_node(pos1).name, "unbreakable") == 1 then
                        minetest.set_node(pos1, {name="nssm:web"})
                    end
                end
            end
        end
    end,
})

minetest.register_craft({
    output = 'nssm:cobweb_bomb 8',
    recipe = {
        {'nssm:silk_gland', 'nssm:black_powder', 'nssm:silk_gland'},
        {'nssm:black_powder', 'nssm:black_powder', 'nssm:black_powder'},
        {'nssm:silk_gland', 'nssm:black_powder', 'nssm:silk_gland'},
    }
})

nssm_register_throwitem("ice", "Ice Bomb", {
    hit_node = function(self,pos)
        for dx = -1,1 do
            for dy = 1,3 do
                for dz = -1,1 do
                    local pos1 = {x = pos.x+dx, y=pos.y+dy, z=pos.z+dz}
                    local pos2 = {x = pos.x, y=pos.y+1, z=pos.z}
                    local pos3 = {x = pos.x, y=pos.y+2, z=pos.z}
                    if not minetest.is_protected(pos1, "") or not minetest.get_item_group(minetest.get_node(pos1).name, "unbreakable") == 1 then
                        minetest.set_node(pos1, {name="default:ice"})
                        minetest.set_node(pos2, {name="air"})
                        minetest.set_node(pos3, {name="air"})
                    end
                end
            end
        end
    end,
})

minetest.register_craft({
    output = 'nssm:ice_bomb 8',
    recipe = {
        {'nssm:frosted_amphibian_heart', 'nssm:black_powder', 'nssm:frosted_amphibian_heart'},
        {'nssm:black_powder', 'nssm:black_powder', 'nssm:black_powder'},
        {'nssm:frosted_amphibian_heart', 'nssm:black_powder', 'nssm:frosted_amphibian_heart'},
    }
})
if minetest.get_modpath("nssb") then
    nssm_register_throwitem("mantis", "Mantis Clay Bomb", {
        hit_node = function(self,pos)
            for dx = -1,1 do
                for dy = 1,3 do
                    for dz = -1,1 do
                        local pos1 = {x = pos.x+dx, y=pos.y+dy, z=pos.z+dz}
                        local pos2 = {x = pos.x, y=pos.y+1, z=pos.z}
                        local pos3 = {x = pos.x, y=pos.y+2, z=pos.z}
                        if not minetest.is_protected(pos1, "") or not minetest.get_item_group(minetest.get_node(pos1).name, "unbreakable") == 1 then
                            minetest.set_node(pos1, {name="nssb:hardened_mantis_clay"})
                            minetest.set_node(pos2, {name="air"})
                            minetest.set_node(pos3, {name="air"})
                        end
                    end
                end
            end
        end,
    })

    minetest.register_craft({
        output = 'nssm:mantis_bomb 8',
        recipe = {
            {'nssm:mantis_meat', 'nssm:black_powder', 'nssm:mantis_meat'},
            {'nssm:black_powder', 'nssb:hardened_mantis_clay', 'nssm:black_powder'},
            {'nssm:mantis_meat', 'nssm:black_powder', 'nssm:mantis_meat'},
        }
    })
end

nssm_register_throwitem("lava", "Lava Bomb", {
    hit_node = function(self,pos)
        for dx = -1,1 do
            for dy = -1,0 do
                for dz = -1,1 do
                    local pos1 = {x = pos.x+dx, y=pos.y+dy, z=pos.z+dz}
                    if not minetest.is_protected(pos1, "") or not minetest.get_item_group(minetest.get_node(pos1).name, "unbreakable") == 1 then
                        minetest.set_node(pos1, {name="default:lava_source"})
                    end
                end
            end
        end
    end,
})

minetest.register_craft({
    output = 'nssm:lava_bomb 12',
    recipe = {
        {'bucket:bucket_lava', 'nssm:black_powder', 'bucket:bucket_lava'},
        {'nssm:black_powder', 'nssm:lava_titan_eye', 'nssm:black_powder'},
        {'bucket:bucket_lava', 'nssm:black_powder', 'bucket:bucket_lava'},
    }
})

nssm_register_throwitem("water", "Water Bomb", {
    hit_node = function(self,pos)
        for dx = -2,2 do
            for dy = -1,0 do
                for dz = -2,2 do
                    local pos1 = {x = pos.x+dx, y=pos.y+dy, z=pos.z+dz}
                    if not minetest.is_protected(pos1, "") or not minetest.get_item_group(minetest.get_node(pos1).name, "unbreakable") == 1 then
                        minetest.set_node(pos1, {name="default:water_source"})
                    end
                end
            end
        end
    end,
})

minetest.register_craft({
    output = 'nssm:water_bomb 10',
    recipe = {
        {'bucket:bucket_water', 'nssm:black_powder', 'bucket:bucket_water'},
        {'nssm:black_powder', 'nssm:tentacle_curly', 'nssm:black_powder'},
        {'bucket:bucket_water', 'nssm:black_powder', 'bucket:bucket_water'},
    }
})

nssm_register_throwitem("fire", "Fire Bomb", {
    hit_node = function(self,pos)
        for dx = -1,1 do
            for dy = 1,1 do
                for dz = -1,1 do
                    local pos1 = {x = pos.x+dx, y=pos.y+dy, z=pos.z+dz}
                    if not minetest.is_protected(pos1, "") or not minetest.get_item_group(minetest.get_node(pos1).name, "unbreakable") == 1 then
                        minetest.set_node(pos1, {name="fire:basic_flame"})
                    end
                end
            end
        end
    end,
})

minetest.register_craft({
    output = 'nssm:fire_bomb 6',
    recipe = {
        {'fire:flint_and_steel', 'nssm:black_powder', 'fire:flint_and_steel'},
        {'nssm:black_powder', 'nssm:black_powder', 'nssm:black_powder'},
        {'fire:flint_and_steel', 'nssm:black_powder', 'fire:flint_and_steel'},
    }
})

if minetest.get_modpath("nssb") then
    nssm_register_throwitem("mornar", "Mornar Bomb", {
        hit_node = function(self,pos)
            for dx = -1,1 do
                for dy = 1,1 do
                    for dz = -1,1 do
                        local pos1 = {x = pos.x+dx, y=pos.y+dy, z=pos.z+dz}
                        if not minetest.is_protected(pos1, "") or not minetest.get_item_group(minetest.get_node(pos1).name, "unbreakable") == 1 then
                            minetest.set_node(pos1, {name="nssb:mornar"})
                        end
                    end
                end
            end
        end,
    })

    minetest.register_craft({
        output = 'nssm:mornar_bomb 6',
        recipe = {
            {'nssm:wrathful_soul_fragment', 'nssm:black_powder', 'nssm:wrathful_soul_fragment'},
            {'nssm:black_powder', 'nssm:wrathful_soul_fragment', 'nssm:black_powder'},
            {'nssm:wrathful_soul_fragment', 'nssm:black_powder', 'nssm:wrathful_soul_fragment'},
        }
    })
end

nssm_register_throwitem("hole", "Hole Bomb", {
    hit_node = function(self,pos)
        for dx = -1,1 do
            for dy = -10,0 do
                for dz = -1,1 do
                    local pos1 = {x = pos.x+dx, y=pos.y+dy, z=pos.z+dz}
                    if not minetest.is_protected(pos1, "") or not minetest.get_item_group(minetest.get_node(pos1).name, "unbreakable") == 1 then
                        minetest.set_node(pos1, {name="air"})
                    end
                end
            end
        end
    end,
})

minetest.register_craft({
    output = 'nssm:hole_bomb 10',
    recipe = {
        {'nssm:black_powder', 'nssm:black_powder', 'nssm:black_powder'},
        {'nssm:black_powder', 'nssm:digested_sand', 'nssm:black_powder'},
        {'nssm:black_powder', 'nssm:black_powder', 'nssm:black_powder'},
    }
})

nssm_register_throwitem("food", "Food Bomb", {
    hit_node = function(self,pos)
        for dx = -1,1 do
            for dy = -1,1 do
                for dz = -1,1 do
                    local pos1 = {x = pos.x+dx, y=pos.y+dy, z=pos.z+dz}
                    if not minetest.is_protected(pos1, "") or not minetest.get_item_group(minetest.get_node(pos1).name, "unbreakable") == 1 then
                        minetest.set_node(pos1, {name="air"})
                        minetest.add_item(pos1, "nssm:roasted_duck_legs")
                    end
                end
            end
        end
    end,
})

minetest.register_craft({
    output = 'nssm:food_bomb 8',
    recipe = {
        {'nssm:gluttonous_soul_fragment', 'nssm:black_powder', 'nssm:gluttonous_soul_fragment'},
        {'nssm:black_powder', 'nssm:gluttonous_soul_fragment', 'nssm:black_powder'},
        {'nssm:gluttonous_soul_fragment', 'nssm:black_powder', 'nssm:gluttonous_soul_fragment'},
    }
})

nssm_register_throwitem("phoenix_fire", "Phoenix Fire Bomb", {
    hit_node = function(self,pos)
        for dx = -2,2 do
            for dy = 0,1 do
                for dz = -2,2 do
                    local pos1 = {x = pos.x+dx, y=pos.y+dy, z=pos.z+dz}
                    if not minetest.is_protected(pos1, "") or not minetest.get_item_group(minetest.get_node(pos1).name, "unbreakable") == 1 then
                        minetest.set_node(pos1, {name="nssm:phoenix_fire"})
                    end
                end
            end
        end
    end,
})

minetest.register_craft({
    output = 'nssm:phoenix_fire_bomb 10',
    recipe = {
        {'nssm:black_powder', 'nssm:black_powder', 'nssm:black_powder'},
        {'nssm:black_powder', 'nssm:sun_feather', 'nssm:black_powder'},
        {'nssm:black_powder', 'nssm:black_powder', 'nssm:black_powder'},
    }
})

nssm_register_throwitem("kaboom", "Explosive Bomb", {
    hit_node = function(self,pos)
                    local pos1 = {x = pos.x, y=pos.y, z=pos.z}
                    if not minetest.is_protected(pos1, "") or not minetest.get_item_group(minetest.get_node(pos1).name, "unbreakable") == 1 then
                        tnt.boom(pos1, {damage_radius=3,radius=2,ignore_protection=false})
                    end
    end,
})

minetest.register_craft({
    output = 'nssm:kaboom_bomb 3',
    recipe = {
        {'nssm:black_powder', 'nssm:black_powder', 'nssm:black_powder'},
        {'nssm:black_powder', 'nssm:black_powder', 'nssm:black_powder'},
        {'nssm:black_powder', 'nssm:black_powder', 'nssm:black_powder'},
    }
})

nssm_register_throwitem("teleport", "Teleport Bomb", {
    hit_node = function(self,pos,placer)
                    local pos1 = {x = pos.x, y=pos.y+1, z=pos.z}
                    local pos2 = {x = pos.x, y=pos.y+2, z=pos.z}
                        if not minetest.is_protected(pos1, "") or not minetest.get_item_group(minetest.get_node(pos1).name, "unbreakable") == 1 then
                            for _,obj in ipairs(minetest.get_objects_inside_radius(posthrow, 2)) do
                                if obj:is_player() then
                                    obj:setpos(pos1)
                                    minetest.set_node(pos1, {name="air"})
                                    minetest.set_node(pos2, {name="air"})
                                end
                            end
                        end
    end,
})

minetest.register_craft({
    output = 'nssm:teleport_bomb 10',
    recipe = {
        {'nssm:slothful_soul_fragment', 'nssm:black_powder', 'nssm:slothful_soul_fragment'},
        {'nssm:black_powder', 'nssm:slothful_soul_fragment', 'nssm:black_powder'},
        {'nssm:slothful_soul_fragment', 'nssm:black_powder', 'nssm:slothful_soul_fragment'},
    }
})

nssm_register_throwitem("boom", "Boom Bomb", {
    hit_node = function(self,pos)
                    local pos1 = {x = pos.x, y=pos.y, z=pos.z}
                    if not minetest.is_protected(pos1, "") or not minetest.get_item_group(minetest.get_node(pos1).name, "unbreakable") == 1 then
                        tnt.boom(pos1, {damage_radius=4,radius=3,ignore_protection=false})
                    end
    end,
})

minetest.register_craft({
    output = 'nssm:boom_bomb 10',
    recipe = {
        {'nssm:greedy_soul_fragment', 'nssm:black_powder', 'nssm:greedy_soul_fragment'},
        {'nssm:black_powder', 'nssm:greedy_soul_fragment', 'nssm:black_powder'},
        {'nssm:greedy_soul_fragment', 'nssm:black_powder', 'nssm:greedy_soul_fragment'},
    }
})

nssm_register_throwitem("smoke", "Smoke Bomb", {
    hit_node = function(self,pos)
                    local pos1 = {x = pos.x, y=pos.y, z=pos.z}
                    minetest.add_particlespawner({
                        amount = 6000,
                        time = 20,
                        minpos = {x=pos1.x-3, y=pos1.y+0.5, z=pos1.z-3},
                        maxpos = {x=pos1.x+3, y=pos1.y+0.5, z=pos1.z+3},
                        minvel = {x=0.2, y=0.2, z=0.2},
                        maxvel = {x=0.4, y=0.8, z=0.4},
                        minacc = {x=-0.2,y=0,z=-0.2},
                        maxacc = {x=0.2,y=0.1,z=0.2},
                        minexptime = 6,
                        maxexptime = 8,
                        minsize = 10,
                        maxsize = 12,
                        collisiondetection = false,
                        vertical = false,
                        texture = "tnt_smoke.png",})
    end,
})

minetest.register_craft({
    output = 'nssm:smoke_bomb 6',
    recipe = {
        {'nssm:proud_soul_fragment', 'nssm:black_powder', 'nssm:proud_soul_fragment'},
        {'nssm:black_powder', 'nssm:proud_soul_fragment', 'nssm:black_powder'},
        {'nssm:proud_soul_fragment', 'nssm:black_powder', 'nssm:proud_soul_fragment'},
    }
})

nssm_register_throwitem("thick_web", "Thick Web Bomb", {
    hit_node = function(self,pos)
                    local pos1 = {x = pos.x, y=pos.y+1, z=pos.z}
                    local pos2 = {x = pos.x, y=pos.y+2, z=pos.z}
                    if not minetest.is_protected(pos1, "") or not minetest.get_item_group(minetest.get_node(pos1).name, "unbreakable") == 1 then
                        minetest.set_node(pos1, {name="nssm:thick_web"})
                        minetest.set_node(pos2, {name="nssm:thick_web"})
                    end
    end,
})

minetest.register_craft({
    output = 'nssm:thick_web_bomb 12',
    recipe = {
        {'nssm:super_silk_gland', 'nssm:black_powder', 'nssm:super_silk_gland'},
        {'nssm:black_powder', 'nssm:black_powder', 'nssm:black_powder'},
        {'nssm:super_silk_gland', 'nssm:black_powder', 'nssm:super_silk_gland'},
    }
})

nssm_register_throwitem("poison", "Poison Bomb", {
    hit_node = function(self,pos)
        for dx = -1,1 do
            for dy = 1,3 do
                for dz = -1,1 do
                    local pos1 = {x = pos.x+dx, y=pos.y+dy, z=pos.z+dz}
                    if not minetest.is_protected(pos1, "") or not minetest.get_item_group(minetest.get_node(pos1).name, "unbreakable") == 1 then
                        minetest.set_node(pos1, {name="nssm:venomous_gas"})
                    end
                end
            end
        end
    end,
})

minetest.register_craft({
    output = 'nssm:poison_bomb 10',
    recipe = {
        {'nssm:black_powder', 'nssm:black_powder', 'nssm:black_powder'},
        {'nssm:black_powder', 'nssm:snake_scute', 'nssm:black_powder'},
        {'nssm:black_powder', 'nssm:black_powder', 'nssm:black_powder'},
    }
})

nssm_register_throwitem("stone", "Cobblestone Bomb", {
    hit_node = function(self,pos)
        for dx = -1,1 do
            for dy = 1,3 do
                for dz = -1,1 do
                    local pos1 = {x = pos.x+dx, y=pos.y+dy, z=pos.z+dz}
                    if not minetest.is_protected(pos1, "") or not minetest.get_item_group(minetest.get_node(pos1).name, "unbreakable") == 1 then
                        minetest.set_node(pos1, {name="default:cobble"})
                    end
                end
            end
        end
    end,
})

minetest.register_craft({
    output = 'nssm:stone_bomb 6',
    recipe = {
        {'default:stone', 'nssm:black_powder', 'default:stone'},
        {'nssm:black_powder', 'nssm:black_powder', 'nssm:black_powder'},
        {'default:stone', 'nssm:black_powder', 'default:stone'},
    }
})

nssm_register_throwitem("fire_ring", "Fire Ring Bomb", {
    hit_node = function(self,pos)
        for dx = -2,2 do
            for dy = 1,2 do
                for dz = -2,2 do
                    local pos1 = {x = pos.x+dx, y=pos.y+dy, z=pos.z+dz}
                    if not minetest.is_protected(pos1, "") or not minetest.get_item_group(minetest.get_node(pos1).name, "unbreakable") == 1 then
                        minetest.set_node(pos1, {name="fire:basic_flame"})
                         for dx = -1,1 do
                            for dy = 1,2 do
                                for dz = -1,1 do
                                    local pos1 = {x = pos.x+dx, y=pos.y+dy, z=pos.z+dz}
                                    minetest.set_node(pos1, {name="air"})
                                end
                            end
                        end
                    end
                end
            end
        end
    end,
})

minetest.register_craft({
    output = 'nssm:fire_ring_bomb 3',
    recipe = {
        {'fire:flint_and_steel', 'fire:flint_and_steel', 'fire:flint_and_steel'},
        {'fire:flint_and_steel', 'nssm:black_powder', 'fire:flint_and_steel'},
        {'fire:flint_and_steel', 'fire:flint_and_steel', 'fire:flint_and_steel'},
    }
})

if minetest.get_modpath("nssb") then
    nssm_register_throwitem("cage", "Cage Bomb", {
        hit_node = function(self,pos)
            for dx = -2,2 do
                for dy = 0,3 do
                    for dz = -2,2 do
                        local pos1 = {x = pos.x+dx, y=pos.y+dy, z=pos.z+dz}
                        if not minetest.is_protected(pos1, "") or not minetest.get_item_group(minetest.get_node(pos1).name, "unbreakable") == 1 then
                            minetest.set_node(pos1, {name="nssb:morentir"})
                             for dx = -1,1 do
                                for dy = 1,2 do
                                    for dz = -1,1 do
                                        local pos1 = {x = pos.x+dx, y=pos.y+dy, z=pos.z+dz}
                                        minetest.set_node(pos1, {name="air"})
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end,
    })

    minetest.register_craft({
        output = 'nssm:cage_bomb 10',
        recipe = {
            {'nssm:lustful_soul_fragment', 'nssm:black_powder', 'nssm:lustful_soul_fragment'},
            {'nssm:black_powder', 'nssm:lustful_soul_fragment', 'nssm:black_powder'},
            {'nssm:lustful_soul_fragment', 'nssm:black_powder', 'nssm:lustful_soul_fragment'},
        }
    })
end
    
nssm_register_throwitem("water_column", "Water Column Bomb", {
    hit_node = function(self,pos)
        for dx = 0,0 do
            for dy = 1,10 do
                for dz = 0,0 do
                    local pos1 = {x = pos.x+dx, y=pos.y+dy, z=pos.z+dz}
                    if not minetest.is_protected(pos1, "") or not minetest.get_item_group(minetest.get_node(pos1).name, "unbreakable") == 1 then
                        minetest.set_node(pos1, {name="default:water_source"})
                    end
                end
            end
        end
    end,
})

minetest.register_craft({
    output = 'nssm:water_column_bomb 6',
    recipe = {
        {'bucket:bucket_water', 'nssm:black_powder', 'bucket:bucket_water'},
        {'bucket:bucket_water', 'nssm:black_powder', 'bucket:bucket_water'},
        {'bucket:bucket_water', 'nssm:black_powder', 'bucket:bucket_water'},
    }
})

minetest.register_craft({
    output = 'nssm:empty_evocation_bomb 10',
    recipe = {
        {'nssm:envious_soul_fragment', 'nssm:black_powder', 'nssm:envious_soul_fragment'},
        {'nssm:black_powder', 'nssm:envious_soul_fragment', 'nssm:black_powder'},
        {'nssm:envious_soul_fragment', 'nssm:black_powder', 'nssm:envious_soul_fragment'},
    }
})

function nssm_register_throwegg(name, descr, def)

    minetest.register_craftitem("nssm:"..name.."_bomb", {
        description = descr,
        inventory_image = "evocation_bomb.png^"..name.."_egg.png",
        on_use = function(itemstack, placer, pointed_thing)
            --weapons_shot(itemstack, placer, pointed_thing, def.velocity, name)
            local velocity = 15
            local dir = placer:get_look_dir();
            local playerpos = placer:getpos();
            local obj = minetest.env:add_entity({x=playerpos.x+0+dir.x,y=playerpos.y+2+dir.y,z=playerpos.z+0+dir.z}, "nssm:"..name.."_bomb_flying")
            local vec = {x=dir.x*velocity,y=dir.y*velocity,z=dir.z*velocity}
            local acc = {x=0, y=-9.8, z=0}
            obj:setvelocity(vec)
            obj:setacceleration(acc)
            itemstack:take_item()
            return itemstack
        end,
    })

    minetest.register_entity("nssm:"..name.."_bomb_flying",{
        textures = {"evocation_bomb.png^"..name.."_egg.png"},
        on_step = function(self, dtime)
            local pos = self.object:getpos()
            local node = minetest.get_node(pos)
            local n = node.name
            if n ~= "air" then
                def.hit_node(self, pos)
                self.object:remove()
            end
        end,
    })
end


