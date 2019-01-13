-- Basic NSSM Tools

minetest.register_node("nssm:rope", {
    description = "Rope",
    paramtype = "light",
    walkable = false,
    climbable = true,
    sunlight_propagates = true,
    drawtype = "plantlike",
    drops = "nssm:rope",
    tiles = { "rope.png" },
    groups = {snappy=1},
})

-- Sun Sword
-- Good sword, sets things on fire...

minetest.register_tool('nssm:sun_sword', {
    description = 'Sun Sword',
    inventory_image = 'sun_sword.png',
    tool_capabilities = {
        full_punch_interval = 0.6,
        max_drop_level=1,
        groupcaps={
            snappy={times={[1]=0.80, [2]=0.40, [3]=0.20}, uses=70, maxlevel=1},
            fleshy={times={[2]=0.6, [3]=0.2}, uses=70, maxlevel=1}
        },
        damage_groups = {fleshy=10},
    },
})

minetest.register_on_punchnode(function(pos, node, puncher, pointed_thing)
    if puncher:get_wielded_item():get_name() == 'nssm:sun_sword' then
        if not nssm.unswappable_node(pos) then
            minetest.add_node(pointed_thing.above, {name = "fire:basic_flame"})
        end
    end
end)

-- Swords

minetest.register_tool("nssm:ant_sword", {
    description = "Ant Sword",
    inventory_image = "ant_sword.png",
    tool_capabilities = {
        full_punch_interval = 0.8,
        max_drop_level=1,
        groupcaps={
            snappy={times={[1]=1.30, [2]=0.90, [3]=0.40}, uses=40, maxlevel=3},
        },
        damage_groups = {fleshy=8},
    },
})

minetest.register_tool("nssm:mantis_sword", {
    description = "Mantis Sword",
    inventory_image = "mantis_sword.png",
    tool_capabilities = {
        full_punch_interval =0.7 ,
        max_drop_level=1,
        groupcaps={
            fleshy={times={[2]=1.0, [3]=0.4}, uses=30, maxlevel=1},
            snappy={times={[1]=1.0, [2]=0.80, [3]=0.3}, uses=40, maxlevel=1},
        },
        damage_groups = {fleshy=7},
    },
})

minetest.register_tool("nssm:masticone_fang_sword", {
    description = "Masticone Fang Sword",
    inventory_image = "masticone_fang_sword.png",
    tool_capabilities = {
        full_punch_interval =0.7 ,
        max_drop_level=1,
        groupcaps={
            snappy={times={[1]=0.6, [2]=0.5, [3]=0.4}, uses=200, maxlevel=1},
            fleshy={times={[2]=0.8, [3]=0.4}, uses=200, maxlevel=1}
        },
        damage_groups = {fleshy=8},
    },
})

minetest.register_tool("nssm:night_sword", {
    description = "Night Sword",
    inventory_image = "night_sword.png",
    tool_capabilities = {
        full_punch_interval =0.4 ,
        max_drop_level=1,
        groupcaps={
            snappy={times={[1]=0.4, [2]=0.3, [3]=0.2}, uses=300, maxlevel=1},
            fleshy={times={[2]=0.7, [3]=0.3}, uses=300, maxlevel=1}
        },
        damage_groups = {fleshy=12},
    },
})

-- Axes

minetest.register_tool("nssm:mantis_battleaxe", {
    description = "Mantis Battleaxe",
    inventory_image = "mantis_battleaxe.png",
    tool_capabilities = {
        full_punch_interval =3 ,
        max_drop_level=1,
        groupcaps={
            fleshy={times={[2]=2, [3]=1.4}, uses=20, maxlevel=1}
        },
        damage_groups = {fleshy=10},
    },
})

minetest.register_tool("nssm:mantis_axe", {
    description = "Mantis Axe",
    inventory_image = "mantis_axe.png",
    tool_capabilities = {
        full_punch_interval = 0.8,
        max_drop_level=1,
        groupcaps={
            choppy={times={[1]=2.20, [2]=1.00, [3]=0.60}, uses=30, maxlevel=3},
        },
        damage_groups = {fleshy=5},
    },
})

-- Picks

minetest.register_tool("nssm:duck_beak_pick",{
    description = "Duck Beak Pickaxe",
    inventory_image = "duck_beak_pick.png",
    tool_capabilities = {
        full_punch_interval = 0.6,
        max_drop_level=3,
        groupcaps={
            cracky = {times={[1]=1.0, [2]=0.8, [3]=0.20}, uses=3, maxlevel=3},
        },
        damage_groups = {fleshy=5},
        },
})

minetest.register_tool("nssm:ant_pick", {
    description = "Ant Pickaxe",
    inventory_image = "ant_pick.png",
    tool_capabilities = {
        full_punch_interval = 1.2,
        max_drop_level=1,
        groupcaps={
            cracky = {times={[1]=2.00, [2]=1.20, [3]=0.80}, uses=30, maxlevel=2},
        },
        damage_groups = {fleshy=4},
    },
})

minetest.register_tool("nssm:mantis_pick", {
    description = "Mantis Pickaxe",
    inventory_image = "mantis_pick.png",
    tool_capabilities = {
        full_punch_interval = 1,
        max_drop_level=1,
        groupcaps={
            cracky = {times={[1]=1.6, [2]=1.0, [3]=0.60}, uses=20, maxlevel=2},
        },
        damage_groups = {fleshy=4},
    },
})

minetest.register_tool("nssm:stoneater_pick", {
    description = "Stoneater Pickaxe",
    inventory_image = "stoneater_pick.png",
    tool_capabilities = {
        full_punch_interval = 0.9,
        max_drop_level=0,
        groupcaps={
            cracky = {times={[3]=0.0}, uses=200, maxlevel=1},
        },
        damage_groups = {fleshy=5},
    },
})

-- Knives

minetest.register_tool("nssm:little_ice_tooth_knife", {
    description = "Little Ice Tooth Knife",
    inventory_image = "little_ice_tooth_knife.png",
    tool_capabilities = {
        full_punch_interval =0.3 ,
        max_drop_level=1,
        groupcaps={
            fleshy={times={[2]=1.0, [3]=0.4}, uses=4, maxlevel=1},
            snappy={times={[2]=0.80, [3]=0.3}, uses=7, maxlevel=1},
        },
        damage_groups = {fleshy=5},
    },
})

minetest.register_tool("nssm:manticore_spine_knife", {
    description = "Manticore Spine Knife",
    inventory_image = "manticore_spine_knife.png",
    tool_capabilities = {
        full_punch_interval =0.4 ,
        max_drop_level=1,
        groupcaps={
            fleshy={times={[2]=1.0, [3]=0.4}, uses=6, maxlevel=1},
            snappy={times={[2]=0.80, [3]=0.3}, uses=6, maxlevel=1},
        },
        damage_groups = {fleshy=6},
    },
})

minetest.register_tool("nssm:felucco_knife", {
    description = "Felucco Knife",
    inventory_image = "felucco_knife.png",
    tool_capabilities = {
        full_punch_interval =0.4 ,
        max_drop_level=1,
        groupcaps={
            fleshy={times={[2]=1.0, [3]=0.4}, uses=6, maxlevel=1},
            snappy={times={[2]=0.80, [3]=0.3}, uses=6, maxlevel=1},
        },
        damage_groups = {fleshy=6},
    },
})

-- Shovels

minetest.register_tool("nssm:ant_shovel", {
    description = "Ant Shovel",
    inventory_image = "ant_shovel.png",
    wield_image = "ant_shovel.png^[transformR90",
    tool_capabilities = {
        full_punch_interval = 1,
        max_drop_level=1,
        groupcaps={
            crumbly = {times={[1]=1.50, [2]=0.90, [3]=0.40}, uses=35, maxlevel=2},
        },
        damage_groups = {fleshy=4},
    },
})

minetest.register_tool("nssm:duck_beak_shovel", {
    description = "Duck Beak Shovel",
    inventory_image = "duck_beak_shovel.png",
    wield_image = "duck_beak_shovel.png^[transformR90",
    tool_capabilities = {
        full_punch_interval = 0.6,
        max_drop_level=1,
        groupcaps={
            crumbly = {times={[1]=1.10, [2]=0.80, [3]=0.20}, uses=5, maxlevel=2},
        },
        damage_groups = {fleshy=4},
    },
})

-- Misc

minetest.register_tool("nssm:ant_billhook", {
    description = "Ant Billhook",
    inventory_image = "ant_billhook.png",
    tool_capabilities = {
        full_punch_interval = 0.8,
        max_drop_level=1,
        groupcaps={
            choppy={times={[1]=1.40, [2]=1.00, [3]=0.60}, uses=30, maxlevel=3},
            snappy={times={[1]=1.40, [2]=1.00, [3]=0.60}, uses=30, maxlevel=3},
        },
        damage_groups = {fleshy=6},
        },
    })

minetest.register_tool("nssm:tarantula_warhammer", {
    description = "Tarantula Warhammer",
    inventory_image = "tarantula_warhammer.png",
    wield_scale= {x=2,y=2,z=1.5},
    tool_capabilities = {
        full_punch_interval =1,
        max_drop_level=1,
        groupcaps={
            cracky={times={[1]=0.6, [2]=0.5, [3]=0.4}, uses=80, maxlevel=1},
            fleshy={times={[2]=0.8, [3]=0.4}, uses=200, maxlevel=1}
        },
        damage_groups = {fleshy=13},
    },
})

minetest.register_tool("nssm:crab_light_mace", {
    description = "Light Crab Mace",
    inventory_image = "crab_light_mace.png",
    tool_capabilities = {
        full_punch_interval =2 ,
        max_drop_level=1,
        groupcaps={
            fleshy={times={[2]=1.4, [3]=1}, uses=20, maxlevel=1}
        },
        damage_groups = {fleshy=8},
    },
})

minetest.register_tool("nssm:crab_heavy_mace", {
    description = "Heavy Crab Mace",
    inventory_image = "crab_heavy_mace.png",
    tool_capabilities = {
        full_punch_interval =4 ,
        max_drop_level=1,
        groupcaps={
            fleshy={times={[2]=2, [3]=1.4}, uses=20, maxlevel=1}
        },
        damage_groups = {fleshy=12},
    },
})

-- Cobweb scickles

local function register_nssm_scickle(name, description, material, diggerlevel)
    minetest.register_tool("nssm:"..name.."_scickle", {
        description = description.." Scickle",
        inventory_image = "nssm_"..name.."_scickle.png",
        groups = {webdigger = diggerlevel},
        tool_capabilities = {
            full_punch_interval =0.7 ,
            max_drop_level=1,
            groupcaps={
                fleshy={times={[2]=1.0, [3]=0.4}, uses=30, maxlevel=1},
                snappy={times={[1]=1.0, [2]=0.80, [3]=0.3}, uses=60, maxlevel=1},
            },
            damage_groups = {fleshy=4},
        },
    })

    minetest.register_craft({
        output = 'nssm:'..name..'_scickle',
        recipe = {
            {material, material},
            {'', 'group:stick'},
        }
    })

    minetest.register_alias("nssm:"..name.."_hoe", "nssm:"..name.."_scickle")
end

register_nssm_scickle("ant", "Ant", "nssm:ant_mandible", 1)
register_nssm_scickle("felucco", "Felucco", "nssm:felucco_horn", 2)

