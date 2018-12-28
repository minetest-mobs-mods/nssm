--[[

Server node tool to protect from mobs.

Not in creative inventory, intended for admin use only.

--]]

local inhibition_radius = 32

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
    groups = {cracky = 3, level = 2, not_in_creative_inventory = 1},
    sounds = default.node_sound_stone_defaults(),
})

local function inhibit_effect(pos,radius)
    radius = radius or 1

    minetest.add_particlespawner(
            80, --amount
            1, --time
            {x=pos.x-radius/2, y=pos.y-radius/2, z=pos.z-radius/2}, --minpos
            {x=pos.x+radius/2, y=pos.y+radius/2, z=pos.z+radius/2}, --maxpos
            {x=-0, y=-0, z=-0}, --minvel
            {x=1, y=1, z=1}, --maxvel
            {x=-0.5,y=5,z=-0.5}, --minacc
            {x=0.5,y=5,z=0.5}, --maxacc
            0.1, --minexptime
            1, --maxexptime
            3, --minsize
            4, --maxsize
            false, --collisiondetection
            "tnt_smoke.png^[colorize:yellow:200^[colorize:white:100" --texture
    )

    minetest.sound_play("nssm_inhibit", {
            pos = pos,
            max_hear_distance = inhibition_radius,
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

        for _,obj in pairs(minetest.get_objects_inside_radius(pos , inhibition_radius)) do
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

