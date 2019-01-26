local nssmleadersfile = minetest.get_worldpath().."/nssm_leaderboard.lua.ser"
local steptime = 0
local mob_descriptions = {}

local function save_leaderboard()
	local serdata = minetest.serialize(nssm.leaderboard)
	if not serdata then
		minetest.log("error", "[NSSM leaderboard] Data serialization failed")
		return
	end
	local file, err = io.open(nssmleadersfile, "w")
	if err then
		return err
	end
	file:write(serdata)
	file:close()
end

local function load_leaderboard()
	local file, err = io.open(nssmleadersfile, "r")
	if not err then
        nssm.leaderboard = minetest.deserialize(file:read("*a"))
        file:close()
	else
		minetest.log("error", "[NSSM leaderboard] Data read failed - initializing")
        nssm.leaderboard = {}
    end
end

load_leaderboard()

-- Globally accessible function
function __NSSM_kill_count(self, pos)
    if self.cause_of_death and
        self.cause_of_death.type == "punch" and
        self.attack and
        self.attack.is_player and
        self.attack:is_player()
        then
        
        local playername = self.attack:get_player_name()
        local playerstats = nssm.leaderboard[playername] or {}
        local killcount = playerstats[self.name] or 0

        playerstats[self.name] = killcount + 1
        nssm.leaderboard[playername] = playerstats -- in case new stat

        minetest.log("action", playername.." defeated "..self.name)
        save_leaderboard()
        -- TODO separate kills hud, or switch on/off kill-messages
        --minetest.chat_send_player(playername, "    (killed: "..mob_descriptions[self.name]..")")
    end
end

local function list_kills(playername)
    if not nssm.leaderboard[playername] then
        return "No stats for "..playername
    end

    local killslist = "Kill stats for "..playername.." :"
    for mob,count in pairs(nssm.leaderboard[playername] or {}) do
        killslist = killslist.."\n"..count.."  "..mob_descriptions[mob]
    end
    return killslist
end

minetest.register_chatcommand("killstats", {
    description = "See your kill stats, or that of other players",
    params = "[<playername>]",
    func = function(playername, params)
        if params ~= "" then
            minetest.chat_send_player(playername, list_kills(params))
        else
            minetest.chat_send_player(playername, list_kills(playername))
        end
    end
})

function nssm:register_mob(name, description, def)
    mob_descriptions[name] = description

    local real_die = def.on_die

    if real_die then
        def.on_die = function(self,pos)
            real_die(self,pos)
            __NSSM_kill_count(self,pos)
        end
    else
        def.on_die = __NSSM_kill_count
    end

    mobs:register_mob(name, def)
end

