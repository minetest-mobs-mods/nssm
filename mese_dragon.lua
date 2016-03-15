nssm:register_mob("nssm:mese_dragon", {
	type = "monster",
	hp_max = 333,
	hp_min = 333,
	collisionbox = {-1, 0, -1, 1, 5, 1},
	visual = "mesh",
	mesh = "mese_dragon.x",
	textures = {{"mese_dragon.png"}},
	visual_size = {x=12, y=12},
	makes_footstep_sound = true,
	maxus = true,
	view_range = 45,
	rotate = 270,
	fear_height = 5,
	walk_velocity = 2,
	run_velocity = 4,
    sounds = {
		shoot_attack = "mesed",
		attack = "mese_dragon",
		distance = 60,
	},
	damage = 16,
	jump = true,
	jump_height = 10,
	drops = {
		{name = "nssm:rainbow_staff",
		chance = 1,
		min = 1,
		max = 1},
		{name = "nssm:energy_globe",
		chance = 1,
		min = 99,
		max = 99},
    },
	armor = 60,
	drawtype = "front",
	water_damage = 0,
	lava_damage = 0,
	light_damage = 0,
	on_rightclick = nil,
	attack_type = "dogshoot",
	dogshoot_stop = true,
	arrow = "nssm:roar_of_the_dragon",
	reach = 5,
	shoot_interval = 3,
	shoot_offset = -1,
	animation = {
		speed_normal = 15,
		speed_run = 25,
		stand_start = 60,
		stand_end = 120,
		walk_start = 161,
		walk_end = 205,
		run_start = 206,
		run_end = 242,
		punch_start = 242,
		punch_end = 275,
		punch1_start = 330,
		punch1_end = 370,
    dattack_start = 120,
    dattack_end = 160,
	},
	do_custom = function(self)
		--transform the blocks he touches in mese_blocks
		local pos = self.object:getpos()
		local c=2
		local v = self.object:getvelocity()
		for dx = -c*(math.abs(v.x))-2 , c*(math.abs(v.x))+2 do
			for dy=-1,10 do
				for dz = -c*(math.abs(v.z))-2 , c*(math.abs(v.z))+2 do
					local p = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
					local t = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
					local n = minetest.env:get_node(p).name
					if (n~="air" and n~="nssm:mese_meteor" and n~="fire:basic_flame") then
							minetest.env:set_node(t, {name="default:mese_block"})
					end
				end
			end
		end
	end,
})
