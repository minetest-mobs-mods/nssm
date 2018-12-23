-- Eggs recipes
-- To be deprecated with drops

minetest.register_craft({
    output = 'nssm:duck',
    recipe = {
        {'', 'nssm:duck_beak', ''},
        {'nssm:duck_feather', 'nssm:energy_globe', 'nssm:duck_feather'},
        {'nssm:duck_legs', 'nssm:duck_feather', 'nssm:duck_legs'},
    }
})

minetest.register_craft({
    output = 'nssm:flying_duck',
    recipe = {
        {'nssm:duck_feather', 'nssm:duck_beak', 'nssm:duck_feather'},
        {'nssm:duck_feather', 'nssm:energy_globe', 'nssm:duck_feather'},
        {'nssm:duck_legs', 'nssm:duck_feather', 'nssm:duck_legs'},
    }
})

minetest.register_craft({
    output = 'nssm:enderduck',
    recipe = {
        {'nssm:black_duck_feather', 'nssm:duck_beak', 'nssm:black_duck_feather'},
        {'nssm:duck_legs', 'nssm:energy_globe', 'nssm:duck_legs'},
        {'nssm:duck_legs', '', 'nssm:duck_legs'},
    }
})

minetest.register_craft({
    output = 'nssm:swimming_duck',
    recipe = {
        {'nssm:duck_feather', 'nssm:duck_beak', 'nssm:duck_feather'},
        {'nssm:duck_legs', 'nssm:energy_globe', 'nssm:duck_legs'},
        {'nssm:duck_feather', 'nssm:duck_feather', 'nssm:duck_feather'},
    }
})

minetest.register_craft({
    output = 'nssm:spiderduck',
    recipe = {
        {'nssm:duck_legs', 'nssm:duck_beak', 'nssm:duck_legs'},
        {'nssm:black_duck_feather', 'nssm:energy_globe', 'nssm:black_duck_feather'},
        {'nssm:duck_legs', 'nssm:black_duck_feather', 'nssm:duck_legs'},
    }
})

minetest.register_craft({
    output = 'nssm:duckking_egg',
    recipe = {
        {'', 'nssm:helmet_crown', ''},
        {'nssm:duck_feather', 'nssm:duck_beak', 'nssm:duck_feather'},
        {'nssm:duck_legs', 'nssm:superior_energy_globe', 'nssm:duck_legs'},
    }
})

minetest.register_craft({
    output = 'nssm:bloco',
    recipe = {
        {'nssm:bloco_skin', 'nssm:bloco_skin', 'nssm:bloco_skin'},
        {'nssm:bloco_skin', 'nssm:energy_globe', 'nssm:bloco_skin'},
        {'nssm:bloco_skin', 'nssm:bloco_skin', 'nssm:bloco_skin'},
    }
})

