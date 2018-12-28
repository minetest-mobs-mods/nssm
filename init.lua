nssm = {}

-- File loading
nssm.path = minetest.get_modpath("nssm")

function nssm:load(filepath)
    dofile(nssm.path.."/"..filepath)
end

-- General API
nssm:load("api/settings.lua")
nssm:load("api/main_api.lua")
nssm:load("api/darts.lua")

--Mobs

nssm:load("mobs/all_mobs.lua")
nssm:load("mobs/spawn.lua")

-- Items etc

nssm:load("materials/materials.lua")

nssm:load("tools/basic.lua")
nssm:load("tools/moranga_tools.lua")
nssm:load("tools/spears.lua")
nssm:load("tools/weapons.lua")
nssm:load("tools/bomb_materials.lua")
nssm:load("tools/bomb_evocation.lua")
nssm:load("tools/rainbow_staff.lua")
nssm:load("tools/armor.lua")

-- Server
nssm:load("materials/mob_protection.lua")
