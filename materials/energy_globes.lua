-- Eat energy for a stats boost

local life_energy_ratings = {}
local coefficients = {
    gravity = 1.4,
    speed = 1.8
}

local players_boost_check = 0
local players_boosted = {}

local function stack_boost(playername, duration)
    local time_remaining = players_boosted[playername]

    if time_remaining then
        time_remaining = time_remaining + duration
    else
        time_remaining = duration
    end

    players_boosted[playername] = time_remaining
    return time_remaining
end

local function drain_boost(playername, duration)
    local time_remaining = players_boosted[playername]

    if not time_remaining then return 0 end

    time_remaining = time_remaining - duration

    if time_remaining <= 0 then
        players_boosted[playername] = nil
        return 0
    end

    players_boosted[playername] = time_remaining

    return time_remaining
end

local function set_player_boost(user, duration, power)
    local antigravity = power or 1.8
    local phys = user:get_physics_override()

    user:set_physics_override({speed = 2, gravity = 0.5})
    local remaining = stack_boost(user:get_player_name(), duration)

    minetest.chat_send_player(user:get_player_name(), "You have "..(math.floor(remaining*10)/10).."s of boost")
end

minetest.register_globalstep(function(dtime)
    local playername, data, remaining

    players_boost_check = players_boost_check + dtime
    local reduce_time = 0
    if players_boost_check > 0.5 then
        reduce_time = players_boost_check
        players_boost_check = 0
    end

    -- Power down players with boosts whose time is run out
    for playername, data in pairs(players_boosted) do
        -- FIXME this is not powering down players, because the draining does not seem to be taking effect
        remaining = drain_boost(playername, reduce_time)
        if remaining <= 0 then
            local player = minetest.get_player_by_name(playername)
            player:set_physics_override({speed = 1, gravity = 1})
        end
    end

end)

local function eat_energy(itemstack, user, pointedthing)

    local nutrition = life_energy_ratings[itemstack:get_name()].nutrition
    local duration = life_energy_ratings[itemstack:get_name()].duration

    local hp = user:get_hp()
    hp = hp + nutrition
    if hp > 20 then hp = 20 end
    user:set_hp(hp)

    set_player_boost(user, duration)

    itemstack:take_item()

    return itemstack
end

-- Define energies

local function register_energy(name, descr, nutrition, duration)
    life_energy_ratings["nssm:"..name] = {nutrition = nutrition, duration = duration}

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

register_energy('life_energy', 'Life Energy', 2, 1)
register_energy('energy_globe', 'Energy Sphere', 5, 2.5)
register_energy('great_energy_globe', 'Great Energy Sphere', 12, 5)
register_energy('superior_energy_globe', 'Awesome Energy Sphere', 18, 10)

register_energy_craft("nssm:life_energy", "nssm:energy_globe")
register_energy_craft("nssm:energy_globe", "nssm:great_energy_globe")
register_energy_craft("nssm:great_energy_globe", "nssm:superior_energy_globe")

