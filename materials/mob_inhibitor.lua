--[[

Server node tool to protect from mobs.

Not in creative inventory, intended for admin use only.

--]]

minetest.register_privilege("mob_inhibitor", {description="Allows placing mob inhibitor blocks"})

minetest.register_node("nssm:mob_inhibitor", {
    description = "NSSM Monster Ward",
    tiles = {
        "default_obsidian.png^proud_soul_fragment.png", -- top
        "default_obsidian.png^greedy_soul_fragment.png", --under
        "default_obsidian.png^phoenix_fire_bomb.png", -- back
        "default_obsidian.png^phoenix_fire_bomb.png", -- side
        "default_obsidian.png^phoenix_fire_bomb.png", --side
        "default_obsidian.png^phoenix_fire_bomb.png", --front
    },
    groups = {unbreakable = 1, not_in_creative_inventory = 1},
    sounds = default.node_sound_stone_defaults(),
    drop = "",
    on_place = function(itemstack, placer, pointed_thing)
        local playername = placer:get_player_name()
        local privs = minetest.get_player_privs(playername)
        if privs.mob_inhibitor then
            return minetest.item_place(itemstack, placer, pointed_thing)
        else
            itemstack:clear()
            return
        end
    end
})

local function inhibit_effect(pos,radius)
    radius = radius or 1

    minetest.add_particlespawner({
            amount = 80,
            time = 1,
            minpos = {x=pos.x-radius/2, y=pos.y-radius/2, z=pos.z-radius/2}, 
            maxpos = {x=pos.x+radius/2, y=pos.y+radius/2, z=pos.z+radius/2}, 
            minlevel = {x=-0, y=-0, z=-0}, 
            maxlevel = {x=1, y=1, z=1}, 
            minacc = {x=-0.5,y=5,z=-0.5}, 
            maxacc = {x=0.5,y=5,z=0.5}, 
            minexptime = 0.1, 
            maxexptime = 1, 
            minsieze = 3,
            maxsieze = 4,
            collisiondetection = false,
            texture = "tnt_smoke.png^[colorize:yellow:200^[colorize:white:100"
    })

    minetest.sound_play("nssm_inhibit", {
            pos = pos,
            max_hear_distance = nssm.inhibition_radius,
    })
end

minetest.register_abm({
    label = "Monster Inhibition Block",
    nodenames = {"nssm:mob_inhibitor"},
    interval = 1,
    chance = 1,
    catch_up = false,
    action = function(pos, node, active_object_count, active_object_count_wider)
        local obj, istring, lua_entity

        for _,obj in pairs(minetest.get_objects_inside_radius(pos , nssm.inhibition_radius)) do
            if not obj:is_player() and obj:get_luaentity() then
                lua_entity = obj:get_luaentity()
                istring = lua_entity["name"]

                -- We got a name, it's nssm and it is a mob
                if istring and istring:sub(1,5) == "nssm:" and lua_entity.health then
                    inhibit_effect(obj:get_pos())
                    obj:remove()
                end
            end
        end
    end,
})

