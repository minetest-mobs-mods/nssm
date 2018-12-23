local life_energy_ratings = {}
local coefficients = {
    gravity = 1.4,
    speed = 1.8
}

local function tell_player_physics(playername, physics)
    minetest.chat_send_player(playername, "Speed: "..physics.speed..", Gravity: "..physics.gravity)
end

local function round_epsilon(num)
    if math.sqrt(math.pow(1 - num, 2)) <= 0.1 then
        return 1
    end
    return num
end

local function round_physics(physics)
    local gravity = math.floor(physics.gravity*100)/100
    local speed = math.floor(physics.speed*100)/100

    -- Prevent infinitessimal derivations due to
    --  floating point math
    gravity = round_epsilon(gravity)
    speed = round_epsilon(speed)

    -- FIXME
    -- If a player dies when in overpowered mode, diferential restores will mess
    --  up their respawned, restored state.
    -- This is a kludge to prevent that problem
    if speed < 1 then speed = 1 end
    if gravity > 1 then gravity = 1 end

    return {gravity = gravity, speed = speed}
end

local function set_player_boost(user, power)
    --[[ FIXME
    There is still a problem here:

    - if the player uses a ton of life energy, they'll enter a super-powered state
        - maybe this can be construed as a feature, as it is hard to control...
    - if the player uses lots of them, their stats may not quite return to origin - specifically, gravity tends
      to remain low (last I tried, my base state became 0.7 gravity

    It may be judicious to in fact see about possibly stacking time, not power... but that would make this more complex still I think...?
    --]]

    phys = round_physics(user:get_physics_override() )

    if phys.speed == 1 and phys.gravity == 1 then
        local newphys = {
            speed = phys.speed * coefficients.speed,
            gravity = phys.gravity/(coefficients.gravity*power),
        }

        newphys = round_physics(newphys)

        local diff = {
            speed = newphys.speed - phys.speed,
            gravity = newphys.gravity - phys.gravity,
        }

        user:set_physics_override(newphys)
        tell_player_physics(user:get_player_name(), newphys)

        stack_boost(user:get_player_name(), power*2.5, diff)
    end

    stack_boost(user:get_player_name(), power*2.5)
end

minetest.register_onstep(function(dtime)
    -- Power down players with boosts
    for -- get each boosted player, apply change

    -- By the time we run the boost removal function, the player's physics
    --  may have been further modified - get the current state of the player
    local boosted_phys = round_physics(user:get_physics_override() )
    local boostcount, gotdiff = unstack_boost(user:get_player_name())

    if boostcount < 1 then
        -- Remove the value of the boost when it was set, leaving the additional boost in place
        local restored_phys = {
            speed = boosted_phys.speed - gotdiff.speed,
            gravity = boosted_phys.gravity - gotdiff.gravity,
        }
        restored_phys = round_physics(restored_phys)
        user:set_physics_override(restored_phys)
        tell_player_physics(user:get_player_name(), restored_phys)
    end
end)

local function eat_energy(itemstack, user, pointedthing)

    local nutrition = life_energy_ratings[itemstack:get_name()].nutrition
    local power = life_energy_ratings[itemstack:get_name()].powerup

    local hp = user:get_hp()
    hp = hp + nutrition
    if hp > 20 then hp = 20 end
    user:set_hp(hp)

    set_player_boost(user, power )

    itemstack:take_item()

    return itemstack
end

local function register_energy(name, descr, nutrition, powerup)
    life_energy_ratings["nssm:"..name] = {nutrition = nutrition, powerup = powerup}

    minetest.register_craftitem("nssm:"..name, {
        description = descr,
        image = name..".png",
        on_use = eat_energy,
    })
end

local function register_energy_craft(smaller,bigger)
    minetest.register_craft({
        output = bigger,
        recipe = {
            {smaller,smaller,smaller},
            {smaller,smaller,smaller},
            {smaller,smaller,smaller},
        }
    })

    minetest.register_craft({
        output = smaller.." 9",
        type = "shapeless",
        recipe = {bigger}
    })
end

register_energy('life_energy', 'Life Energy', 1, 1)
register_energy('energy_globe', 'Energy Sphere', 2, 1.2)
register_energy('great_energy_globe', 'Great Energy Sphere', 5, 1.5)
register_energy('superior_energy_globe', 'Awesome Energy Sphere', 12, 1.9)

register_energy_craft("nssm:life_energy", "nssm:energy_globe")
register_energy_craft("nssm:energy_globe", "nssm:great_energy_globe")
register_energy_craft("nssm:great_energy_globe", "nssm:superior_energy_globe")
