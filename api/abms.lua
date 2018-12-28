--abms

minetest.register_abm({
    nodenames = {"nssm:mese_meteor"},
    neighbors = {"air"},
    interval = 1,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        if minetest.is_protected(pos, "") then
            return
        end
        --local under = {x=pos.x, y=pos.y-1, z=pos.z}
        --local n = minetest.env:get_node(under).name
        --if n~= "air" then
        minetest.set_node({x=pos.x+1, y=pos.y, z=pos.z}, {name = "fire:basic_flame"})
        minetest.set_node({x=pos.x-1, y=pos.y, z=pos.z}, {name = "fire:basic_flame"})
        minetest.set_node({x=pos.x, y=pos.y, z=pos.z-1}, {name = "fire:basic_flame"})
        minetest.set_node({x=pos.x, y=pos.y, z=pos.z+1}, {name = "fire:basic_flame"})
        minetest.set_node({x=pos.x, y=pos.y+1, z=pos.z}, {name = "fire:basic_flame"})

    end
})

minetest.register_abm({
    nodenames = {"nssm:web"},
    neighbors = {"default:junglegrass"},
    interval = 20.0,
    chance = 20,
    action = function(pos, node, active_object_count, active_object_count_wider)
        local n = minetest.env:get_node(pos).name
        if n== "air" then
            minetest.set_node({x = pos.x, y = pos.y + 1, z = pos.z}, {name = "nssm:web"})
        end
    end
})

minetest.register_abm({
    nodenames = {"nssm:web"},
    neighbors = {"default:junglegrass"},
    interval = 20.0,
    chance = 20,
    action = function(pos, node, active_object_count, active_object_count_wider)
        local n = minetest.env:get_node(pos).name
        if n== "air" then
            minetest.set_node({x = pos.x + 1, y = pos.y, z = pos.z}, {name = "nssm:web"})
        end
    end
})

minetest.register_abm({
    nodenames = {"nssm:web"},
    neighbors = {"default:junglegrass"},
    interval = 20.0,
    chance = 20,
    action = function(pos, node, active_object_count, active_object_count_wider)
        local n = minetest.env:get_node(pos).name
        if n == "air" then
            minetest.set_node({x = pos.x - 1, y = pos.y, z = pos.z}, {name = "nssm:web"})
        end
    end
})

minetest.register_abm({
    nodenames = {"nssm:phoenix_fire"},
    neighbors = {"air"},
    interval = 3,
    chance = 2,
    action = function(pos, node)
        minetest.set_node({x = pos.x, y = pos.y , z = pos.z}, {name = "air"})
    end
})

minetest.register_abm({
    nodenames = {"nssm:dead_leaves"},
    neighbors = {"air"},
    interval = 15,
    chance = 3,
    action = function(pos, node)
        minetest.set_node({x = pos.x, y = pos.y , z = pos.z}, {name = "air"})
    end
})
