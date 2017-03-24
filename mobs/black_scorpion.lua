mobs:register_mob("nssm:black_scorpion", {
	type = "monster",
	hp_max = 24,
	hp_min = 17,
	collisionbox = {-0.5, 0.00, -0.5, 0.5, 0.8, 0.5},
	visual = "mesh",
	mesh = "scorpion.x",
	textures = {{"scorpion.png"}},
	visual_size = {x=12, y=12},
	makes_footstep_sound = true,
	view_range = 22,
	walk_velocity = 1,
	fear_height = 4,
	run_velocity = 2.5,
--[[	sounds = {
		random = "black_scorpion",
	},]]
	damage = 4,
	reach = 4,
	jump = true,
	drops = {
		{name = "nssm:life_energy",
		chance = 1,
		min = 1,
		max = 4,},
	},
	armor = 80,
	drawtype = "front",
	water_damage = 1,
	lava_damage = 7,
	light_damage = 0,
	group_attack=true,
	attack_animals=true,
	blood_texture="nssm_blood_blue.png",
	stepheight=1.1,
	on_rightclick = nil,
--	double_melee_attack = true,
	attack_type = "dogfight",
	animation = {
		speed_normal = 20,
		speed_run = 30,
		stand_start = 10,
		stand_end = 60,
		walk_start = 70,
		walk_end = 110,
		run_start = 70,
		run_end = 110,
		punch_start = 160,
		punch_end = 180,
		punch2_start = 120,
		punch2_end = 150,
		die_start = 190,
		die_end = 210,
	},
	custom_attack = function (self)
		if math.random(1,30) == 1 then
			set_animation(self, "punch2")
			self.attack:punch(self.object, 1.0, {
				full_punch_interval = 1.0,
				damage_groups = {fleshy = self.damage*10}
			}, nil)
		else
			set_animation(self, "punch")
			self.attack:punch(self.object, 1.0, {
				full_punch_interval = 1.0,
				damage_groups = {fleshy = self.damage}
			}, nil)
		end
	end,
})
