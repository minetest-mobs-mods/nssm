minetest.register_ore({
    ore_type       = "scatter",
    ore            = "nssm:modders_block",
    wherein        = "default:stone",
    clust_scarcity = 50*50*50,
    clust_num_ores = 1,
    clust_size     = 1,
    y_min          = -115,
    y_max          = -95,
})

for i=1,9 do
    minetest.register_ore({
        ore_type       = "scatter",
        ore            = "nssm:ant_dirt",
        wherein        = "default:cobble",
        clust_scarcity = 1,
        clust_num_ores = 1,
        clust_size     = 1,
        y_min          = -1,
        y_max          = 40,
    })

    minetest.register_ore({
        ore_type       = "scatter",
        ore            = "nssm:ant_dirt",
        wherein        = "default:mossycobble",
        clust_scarcity = 1,
        clust_num_ores = 1,
        clust_size     = 1,
        y_min          = -1000,
        y_max          = 40,
    })

    minetest.register_ore({
        ore_type       = "scatter",
        ore            = "nssm:ant_dirt",
        wherein        = "default:sandstonebrick",
        clust_scarcity = 1,
        clust_num_ores = 1,
        clust_size     = 1,
        y_min          = -1000,
        y_max          = 40,
    })

    minetest.register_ore({
        ore_type       = "scatter",
        ore            = "nssm:ant_dirt",
        wherein        = "stairs:stair_sandstonebrick",
        clust_scarcity = 1,
        clust_num_ores = 1,
        clust_size     = 1,
        y_min          = -1000,
        y_max          = 40,
    })

    minetest.register_ore({
        ore_type       = "scatter",
        ore            = "nssm:ant_dirt",
        wherein        = "stairs:stair_cobble",
        clust_scarcity = 1,
        clust_num_ores = 1,
        clust_size     = 1,
        y_min          = -1000,
        y_max          = 40,
    })
end

minetest.register_ore({
        ore_type       = "scatter",
        ore            = "nssm:web",
        wherein        = "default:junglegrass",
        clust_scarcity = 2*2*2,
        clust_num_ores = 2,
        clust_size     = 2,
        y_min          = -20,
        y_max          = 200,
            })

minetest.register_ore({
        ore_type       = "scatter",
        ore            = "nssm:web",
        wherein        = "default:jungleleaves",
        clust_scarcity = 4*4*4,
        clust_num_ores = 5,
        clust_size     = 5,
        y_min          = -20,
        y_max          = 200,
            }
)

