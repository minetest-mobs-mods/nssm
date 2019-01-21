nssm.leaderboard = {}

local function load_leaderboard()
    -- TODO
end

local function save_leaderboard()
    -- TODO
end

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
    end
end
