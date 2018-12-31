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
    groups = {cracky = 1, level = 4, not_in_creative_inventory = 1},
    sounds = default.node_sound_stone_defaults(),
    drop = "",
    on_place = function(itemstack, placer, pointed_thing)
        local playername = placer:get_player_name()
        local privs = minetest.get_player_privs(playername)

        if privs.mob_inhibitor then
            return minetest.item_place(itemstack, placer, pointed_thing)
        else
            minetest.log("action", playername.." prevented from using nssm:mob_inhibitor")
            return
        end
    end
})

function nssm:inhibit_effect(pos,radius)
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
            texture = "morparticle.png^[colorize:yellow:200^[colorize:white:100"
    })

    minetest.sound_play("nssm_inhibit", {
            pos = pos,
            max_hear_distance = nssm.inhibition_radius,
    })
end

