nssm = {
    version = "20190117",
    maintainer = "taikedz-mt", -- change if forking project
}

-- Pre-check compatibility
--  Downloaded

local mobs_version_required = 20181220

if mobs then
    if not (mobs.version and tonumber(mobs.version) > mobs_version_required) then
        minetest.log("error",
            "Incompatible mobs library (version "..
            tostring(mobs.version)..
            ") loaded. Please use a recent mobs_redo (newer than"..
            mobs_version_required..")"
        )
        os.exit(1) -- Bail early, mainly for servers.
    end
else
    minetest.log("error", "No mobs engine detected. Please use mobs_redo -> https://tinyurl.com/mt-mobs-redo .")
    os.exit(1)
end

-- File loading
nssm.path = minetest.get_modpath("nssm")

function nssm:load(filepath)
    dofile(nssm.path.."/"..filepath)
end

-- Load before all others
nssm:load("api/settings.lua")

-- General API
nssm:load("api/main_api.lua")
nssm:load("api/darts.lua")
nssm:load("api/abms.lua")

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
