nssm:load("materials/craft_items.lua")
nssm:load("materials/ores.lua")
nssm:load("materials/energy_globes.lua")

--nodes

minetest.register_node("nssm:ant_dirt", {
    description = "Ant Dirt",
    tiles = {"ant_dirt.png"},
    groups = {crumbly=3},
})

minetest.register_node("nssm:dead_leaves", {
    description = "Dead leaves",
    tiles = {"dead_leaves.png"},
    groups = {snappy=3,leaves=1},
})

minetest.register_node("nssm:invisible_light", {
    description = "Invisible light source",
    tiles = {"transparent.png"},
    paramtype = "light",
    drawtype = "airlike",
    walkable = false,
    sunlight_propagates = true,
    pointable = false,
    diggable = false,
    buildable_to = true,
    is_ground_content = false,
    groups = {unbreakable=1},
    drop = "",
    light_source = LIGHT_MAX,
})

minetest.register_node("nssm:venomous_gas", {
    description = "Venomous Gas",
    inventory_image = minetest.inventorycube("venomous_gas2.png"),
    drawtype = "firelike",
    tiles = {
        {name="venomous_gas_animated2.png", animation={type="vertical_frames", aspect_w=64, aspect_h=64, length=3.0}}
    },
    paramtype = "light",
    walkable = false,
    sunlight_propagates = true,
    pointable = false,
    diggable = false,
    buildable_to = true,
    drop = "",
    drowning = 1,
    damage_per_second = 1,
    post_effect_color = {a=100, r=1, g=100, b=1},
    groups = {flammable = 2},
})

minetest.register_node("nssm:modders_block", {
    description = "Modders Block",
    tiles = {"modders_block.png"},
    is_ground_content = true,
    groups = {crumbly=3, not_in_creative_inventory =1},
})

minetest.register_node("nssm:web", {
    description = "Web",
    inventory_image = "web.png",
    tiles = {"web.png"} ,
    drawtype = "plantlike",
    paramtype = "light",
    walkable = false,
    pointable = true,
    diggable = true,
    buildable_to = false,
    drop = "farming:cotton",
    drowning = 0,
    liquid_renewable = false,
    liquidtype = "source",
    liquid_range= 0,
    liquid_alternative_flowing = "nssm:web",
    liquid_alternative_source = "nssm:web",
    liquid_viscosity = 20,
    groups = {flammable=2, snappy=1, liquid=1},
    on_dig = function(pos, node, digger)
        local winame = digger:get_wielded_item():get_name()
        local wi = minetest.registered_tools[winame]

        if wi and wi.groups and wi.groups.webdigger then
            local range = (5-wi.groups.webdigger)/2
            local webnodes = minetest.find_nodes_in_area(
                {x=pos.x-range, y=pos.y-range, z=pos.z-range},
                {x=pos.x+range, y=pos.y+range, z=pos.z+range},
                {"nssm:web"}
            )

            for _,nodepos in ipairs(webnodes) do
                if not minetest.is_protected(nodepos, digger:get_player_name()) then
                    minetest.remove_node(nodepos)
                    if math.random(1,range*4) == 1 then
                        minetest.add_item(nodepos, "farming:cotton")
                    end
                end
            end
        else
            minetest.node_dig(pos, node, digger)
        end
    end
})

minetest.register_node("nssm:thick_web", {
    description = "Thick Web",
    inventory_image = "thick_web.png",
    tiles = {"thick_web.png"} ,
    drawtype = "firelike",
    paramtype = "light",
    walkable = false,
    pointable = true,
    diggable = true,
    buildable_to = false,
    drop = "farming:cotton 8",
    drowning = 2,
    liquid_renewable = false,
    liquidtype = "source",
    liquid_range= 0,
    liquid_alternative_flowing = "nssm:thick_web",
    liquid_alternative_source = "nssm:thick_web",
    liquid_viscosity = 30,
    groups = {flammable=2, snappy=1, liquid=1},
})

minetest.register_node("nssm:ink", {
    description = "Ink",
    inventory_image = minetest.inventorycube("ink.png"),
    drawtype = "liquid",
    tiles = {
        {
            name = "ink_animated.png",
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 2.0,
            },
        },
    },
    --alpha = 420,
    paramtype = "light",
    walkable = false,
    pointable = false,
    diggable = false,
    buildable_to = true,
    is_ground_content = false,
    drop = "",
    liquid_range= 0,
    drowning = 1,
    liquid_renewable = false,
    liquidtype = "source",
    liquid_alternative_flowing = "nssm:ink",
    liquid_alternative_source = "nssm:ink",
    liquid_viscosity = 1,
    post_effect_color = {a=2000, r=30, g=30, b=30},
    groups = {water=3, liquid=3, puts_out_fire=1},
})

minetest.register_node("nssm:mese_meteor", {
    description = "Mese Meteor",
    tiles = {"mese_meteor.png"} ,
    paramtype = "light",
    drop = "",
    groups = {crumbly=1, falling_node=1, flammable = 2},
})

minetest.register_node("nssm:pumpbomb", {
    tiles = {"pumpbomb_top.png","pumpbomb_bottom.png", "pumpbomb_side.png", "pumpbomb_side.png", "pumpbomb_side.png", "pumpbomb_front.png"},
    light_source = 5,
    groups = {not_in_creative_inventory =1},
    drop = "",
    on_timer = function(pos, elapsed)
        tnt_boom_nssm(pos, {damage_radius=4,radius=3,ignore_protection=false})
        minetest.env:set_node(pos, {name="air"})
    end,
})

minetest.register_node("nssm:dragons_mese", {
    description = "Mese Dragon's Touch",
    tiles = {"default_mese_block.png"},
    paramtype = "light",
    drop = "default:mese_crystal",
    groups = {cracky = 3, level = 2},
    sounds = default.node_sound_stone_defaults(),
    light_source = 7,
})

minetest.register_node("nssm:phoenix_fire", {
    description = "Phoenix Fire",
    drawtype = "firelike",
    tiles = {{
        name = "phoenix_fire_animated.png",
        animation = {type = "vertical_frames",
            aspect_w = 16, aspect_h = 16, length = 1},
    }},
    inventory_image = "phoenix_fire.png",
    light_source = LIGHT_MAX,
    -- groups = {igniter = 1, snappy=1},
    groups = {snappy=1},
    drop = '',
    walkable = false,
    buildable_to = false,
    damage_per_second = 4,
})



--recipes

minetest.register_craft({
    output = 'nssm:web_string',
    recipe = {
        {'nssm:web', 'nssm:web'},
        {'nssm:web', 'nssm:web'},
    }
})

minetest.register_craft({
    output = 'nssm:dense_web_string',
    recipe = {
        {'nssm:web_string', 'nssm:web_string', 'nssm:web_string'},
        {'nssm:web_string', 'nssm:web_string', 'nssm:web_string'},
        {'nssm:web_string', 'nssm:web_string', 'nssm:web_string'},
    }
})

minetest.register_craft({
    output = 'nssm:mantis_sword',
    recipe = {
        {'nssm:mantis_claw'},
        {'nssm:mantis_claw'},
        {'group:stick'},
    }
})

minetest.register_craft({
    output = 'nssm:masticone_fang_sword',
    recipe = {
        {'nssm:masticone_fang', 'nssm:masticone_fang'},
        {'nssm:masticone_fang', ''},
        {'group:stick', ''},
    }
})

minetest.register_craft({
    output = 'nssm:black_ice_tooth',
    type = "shapeless",
    recipe = {'nssm:digested_sand', 'nssm:ice_tooth'},
})

minetest.register_craft({
    output = 'nssm:web 4',
    type = "shapeless",
    recipe = {'nssm:silk_gland'},
})

minetest.register_craft({
    output = 'nssm:crab_light_mace',
    recipe = {
        {'nssm:crab_chela'},
        {'group:stick'},
        {'group:stick'},
    }
})

minetest.register_craft({
    output = 'nssm:crab_heavy_mace',
    recipe = {
        {'', 'nssm:crab_chela', ''},
        {'nssm:crab_chela', 'nssm:crab_chela', 'nssm:crab_chela'},
        {'', 'group:stick', ''},
    }
})

minetest.register_craft({
    output = 'nssm:mese_egg',
    type = "shapeless",
    recipe = {'nssm:tarantula_chelicerae', 'nssm:helmet_masticone_crowned', 'nssm:eyed_tentacle','nssm:black_ice_tooth', 'nssm:superior_energy_globe', 'nssm:sky_feather','nssm:cursed_pumpkin_seed', 'nssm:ant_queen_abdomen', 'nssm:snake_scute'}
})

minetest.register_craft({
    output = 'nssm:eyed_tentacle',
    type = "shapeless",
    recipe = {'nssm:lava_titan_eye','nssm:tentacle_curly'}
})

--[[
minetest.register_craft({
    output = 'nssm:masticone_skull',
    recipe = {
        {'nssm:masticone_skull_fragments', 'nssm:masticone_skull_fragments', 'nssm:masticone_skull_fragments'},
        {'nssm:masticone_skull_fragments', 'nssm:masticone_skull_fragments', 'nssm:masticone_skull_fragments'},
        {'nssm:masticone_skull_fragments', 'nssm:masticone_skull_fragments', 'nssm:masticone_skull_fragments'},
    }
})]]

minetest.register_craft({
    output = 'nssm:rope 12',
    recipe = {
        {'nssm:web_string'},
        {'nssm:web_string'},
        {'nssm:web_string'},
    }
})

minetest.register_craft({
    output = 'nssm:sky_feather',
    type = "shapeless",
    recipe = {'nssm:sun_feather','nssm:night_feather'}
})

minetest.register_craft({
    output = 'nssm:sun_sword',
    recipe = {
        {'default:diamond'},
        {'nssm:sun_feather'},
        {'group:stick'},
    }
})

minetest.register_craft({
    output = 'nssm:night_sword',
    recipe = {
        {'default:diamond'},
        {'nssm:night_feather'},
        {'group:stick'},
    }
})



minetest.register_craft({
    output = 'nssm:larva_juice',
    type = "shapeless",
    recipe = {'nssm:larva_meat','bucket:bucket_empty'}
})

minetest.register_craft({
    output = 'nssm:ant_sword',
    recipe = {
        {'nssm:ant_mandible'},
        {'nssm:ant_mandible'},
        {'group:stick'},
    }
})

minetest.register_craft({
    output = 'nssm:ant_billhook',
    recipe = {
        {'nssm:ant_mandible', 'nssm:ant_mandible'},
        {'nssm:ant_mandible', 'group:stick'},
        {'', 'group:stick'},
    }
})

minetest.register_craft({
    output = 'nssm:ant_shovel',
    recipe = {
        {'nssm:ant_mandible'},
        {'group:stick'},
        {'group:stick'},
    }
})

minetest.register_craft({
    output = 'nssm:duck_beak_shovel',
    recipe = {
        {'nssm:duck_beak'},
        {'group:stick'},
        {'group:stick'},
    }
})

minetest.register_craft({
    output = 'nssm:duck_beak_pick',
    recipe = {
        {'nssm:duck_beak', 'nssm:duck_beak', 'nssm:duck_beak'},
        {'', 'group:stick', ''},
        {'', 'group:stick', ''},
    }
})

minetest.register_craft({
    output = 'nssm:sky_iron 30',
    recipe = {
        {'default:steelblock', 'default:steelblock', 'default:steelblock'},
        {'default:steelblock', 'nssm:sky_feather', 'default:steelblock'},
        {'default:steelblock', 'default:steelblock', 'default:steelblock'},
    }
})

minetest.register_craft({
    output = 'nssm:stoneater_pick',
    recipe = {
        {'nssm:stoneater_mandible', 'nssm:stoneater_mandible', 'nssm:stoneater_mandible'},
        {'', 'group:stick', ''},
        {'', 'group:stick', ''},
    }
})

minetest.register_craft({
    output = 'nssm:felucco_knife',
    recipe = {
        {'nssm:felucco_horn'},
        {'group:stick'},
    }
})

minetest.register_craft({
    output = 'nssm:little_ice_tooth_knife',
    recipe = {
        {'nssm:little_ice_tooth'},
        {'group:stick'},
    }
})

minetest.register_craft({
    output = 'nssm:manticore_spine_knife',
    recipe = {
        {'nssm:manticore_spine'},
        {'group:stick'},
    }
})

minetest.register_craft({
    output = 'nssm:ant_pick',
    recipe = {
        {'nssm:ant_mandible', 'nssm:ant_mandible', 'nssm:ant_mandible'},
        {'', 'group:stick', ''},
        {'', 'group:stick', ''},
    }
})

minetest.register_craft({
    output = 'nssm:mantis_pick',
    recipe = {
        {'nssm:mantis_claw', 'nssm:mantis_claw', 'nssm:mantis_claw'},
        {'', 'group:stick', ''},
        {'', 'group:stick', ''},
    }
})

minetest.register_craft({
    output = 'nssm:mantis_axe',
    recipe = {
        {'nssm:mantis_claw', 'nssm:mantis_claw'},
        {'nssm:mantis_claw', 'group:stick'},
        {'', 'group:stick'},
    }
})

minetest.register_craft({
    output = 'nssm:tarantula_warhammer',
    recipe = {
        {'nssm:tarantula_chelicerae'},
        {'group:stick'},
        {'group:stick'},
    }
})

minetest.register_craft({
    output = 'nssm:mantis_battleaxe',
    recipe = {
        {'nssm:mantis_claw', 'nssm:mantis_claw', 'nssm:mantis_claw'},
        {'nssm:mantis_claw', 'group:stick', 'nssm:mantis_claw'},
        {'', 'group:stick', ''},
    }
})
--Eggs

function nssm_register_egg (name, descr)
    minetest.register_craftitem("nssm:".. name, {
        description = descr .. " Egg",
        image = name.."_egg.png",
        on_place = function(itemstack, placer, pointed_thing)
            local pos1=minetest.get_pointed_thing_position(pointed_thing, true)
            pos1.y=pos1.y+1.5
            core.after(0.1, function()
                minetest.add_entity(pos1, "nssm:".. name)
            end)
            itemstack:take_item()
            return itemstack
        end,
    })
end

function nssm_register_egg2 (name, descr)                --mobs you can't catch
    minetest.register_craftitem("nssm:".. name.."_egg", {
        description = descr .. " Egg",
        image = name.."_egg.png",
        on_place = function(itemstack, placer, pointed_thing)
            local pos1=minetest.get_pointed_thing_position(pointed_thing, true)
            pos1.y=pos1.y+1.5
            core.after(0.1, function()
                minetest.add_entity(pos1, "nssm:".. name)
            end)
            itemstack:take_item()
            return itemstack
        end,
    })
end

nssm_register_egg ('flying_duck', 'Flying Duck')
nssm_register_egg ('stone_eater', 'Stoneater')
nssm_register_egg ('signosigno', 'Signosigno')
nssm_register_egg ('bloco', 'Bloco')
nssm_register_egg ('sand_bloco', 'Sand Bloco')
nssm_register_egg ('swimming_duck', 'Swimming Duck')
nssm_register_egg ('duck', 'Duck')
nssm_register_egg2 ('duckking', 'Duckking')
nssm_register_egg ('enderduck', 'Enderduck')
nssm_register_egg ('spiderduck', 'Spiderduck')
nssm_register_egg2 ('echidna', 'Echidna')
nssm_register_egg ('werewolf', 'Werewolf')
nssm_register_egg ('white_werewolf', 'White Werewolf')
nssm_register_egg ('snow_biter', 'Snow Biter')
nssm_register_egg2 ('icelamander', 'Icelamander')
nssm_register_egg ('icesnake', 'Icesnake')
nssm_register_egg2 ('lava_titan', 'Lava Titan')
nssm_register_egg ('masticone', 'Masticone')
nssm_register_egg ('mantis_beast', 'Mantis Beast')
nssm_register_egg ('mantis', 'Mantis')
nssm_register_egg ('larva', 'Larva')
nssm_register_egg2 ('phoenix', 'Phoenix')
nssm_register_egg2 ('night_master', 'Night Master')
nssm_register_egg ('scrausics', 'Scrausics')
nssm_register_egg ('moonheron', 'Moonheron')
nssm_register_egg ('sandworm', 'Sandworm')
nssm_register_egg2 ('giant_sandworm', 'Giant Sandworm')
nssm_register_egg2 ('ant_queen', 'Ant Queen')
nssm_register_egg ('ant_soldier', 'Ant Soldier')
nssm_register_egg ('ant_worker', 'Ant Worker')
nssm_register_egg ('crocodile', 'Crocodile')
nssm_register_egg ('dolidrosaurus', 'Dolidrosaurus')
nssm_register_egg ('crab', 'Crab')
nssm_register_egg ('octopus', 'Octopus')
nssm_register_egg ('xgaloctopus', 'Xgaloctopus')
nssm_register_egg ('black_widow', 'Black Widow')
nssm_register_egg ('uloboros', 'Uloboros')
nssm_register_egg2 ('tarantula', 'Tarantula')
nssm_register_egg ('daddy_long_legs', 'Daddy Long Legs')
nssm_register_egg2 ('kraken', 'Kraken')
nssm_register_egg2 ('pumpking', 'Pumpking')
nssm_register_egg ('manticore', 'Manticore')
nssm_register_egg ('felucco', 'Felucco')
nssm_register_egg ('pumpboom_large', 'Large Pumpboom')
nssm_register_egg ('pumpboom_small', 'Small Pumpboom')
nssm_register_egg ('pumpboom_medium', 'Medium Pumpboom')
nssm_register_egg2 ('mordain', 'Mordain')
nssm_register_egg2 ('morgre', 'Morgre')
nssm_register_egg2 ('morvy', 'Morvy')
nssm_register_egg2 ('morgut', 'Morgut')
nssm_register_egg2 ('morde', 'Morde')
nssm_register_egg2 ('morlu', 'Morlu')
nssm_register_egg2 ('morwa', 'Morwa')
nssm_register_egg ('morvalar', 'Morvalar')

minetest.register_craftitem("nssm:mese_egg", {
    description = "Mese Egg",
    image = "mese_egg.png",
    on_place = function(itemstack, placer, pointed_thing)
        local pos1=minetest.get_pointed_thing_position(pointed_thing, true)
        pos1.y=pos1.y+1.5
        minetest.add_particlespawner({
            amount = 1000,
            time = 0.2,
            minpos = {x=pos1.x-1, y=pos1.y-1, z=pos1.z-1},
            maxpos = {x=pos1.x+1, y=pos1.y+4, z=pos1.z+1},
            minvel = {x=0, y=0, z=0},
            maxvel = {x=1, y=5, z=1},
            minacc = {x=-0.5,y=5,z=-0.5},
            maxacc = {x=0.5,y=5,z=0.5},
            minexptime = 1,
            maxexptime = 3,
            minsize = 2,
            maxsize = 4,
            collisiondetection = false,
            vertical = false,
            texture = "tnt_smoke.png",
        })
        core.after(0.4, function()
            minetest.add_entity(pos1, "nssm:mese_dragon")
        end)
        itemstack:take_item()
        return itemstack
    end,
})


--experimental morwa statue
minetest.register_node("nssm:morwa_statue", {
    description = 'Morwa Statue',
    drawtype = 'mesh',
    mesh = 'morwa_statue.b3d',
    tiles = {'morwa_statue.png'},
    inventory_image = 'morwa_statue.png',
    groups = {not_in_creative_inventory=1},
    paramtype = 'light',
    paramtype2 = 'facedir',
    selection_box = {
      type = 'fixed',
      fixed = {-1, -0.5, -1, 1, 3, 1}, -- Right, Bottom, Back, Left, Top, Front
    },
    collision_box = {
      type = 'fixed',
      fixed = {-1, -0.5, -1, 1, 3, 1}, -- Right, Bottom, Back, Left, Top, Front
    },
})
