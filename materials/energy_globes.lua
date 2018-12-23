function nssm:eat_energy(nutrition, speed)
    minetest.item_eat(nutrition)
    -- TODO - add speed, gravity = floor(2/speed)+0.5, protection = protection + 1.5*speed
    -- Something like that ...
end

function nssm:register_energy(name, descr, nutrition, speed)
    minetest.register_craftitem("nssm:"..name, {
        description = descr,
        image = name..".png",
        on_use = nssm:eat_energy(nutrition, speed),
    })
end

local function register_energy_craft(smaller,bigger)
    minetest.register_craft({
        output = bigger,
        recipe = {
            smaller,smaller,smaller,
            smaller,smaller,smaller,
            smaller,smaller,smaller,
        }
    })

    minetest.register_craft({
        output = smaller.." 9",
        type = shapeless,
        recipe = {bigger}
    })
end

nssm:register_energy('life_energy', 'Life Energy', 1)
nssm:register_energy('energy_globe', 'Energy Sphere', 2)
nssm:register_energy('great_energy_globe', 'Great Energy Sphere', 5)
nssm:register_energy('superior_energy_globe', 'Awesome Energy Sphere', 12)

register_energy_craft("nssm:life_energy", "nssm:energy_globe")
register_energy_craft("nssm:energy_globe", "nssm:great_energy_globe")
register_energy_craft("nssm:great_energy_globe", "nssm:superior_energy_globe")
