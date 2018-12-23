nssm.mymapgenis = tonumber(minetest.settings:get('nssm.mymapgenis')) or 7
nssm.multimobs = tonumber(minetest.settings:get('nssm.multimobs')) or 1000

-- Server safe setting - allow a non-griefing rainbow tool
nssm.init_rainbow_staff = minetest.settings:get_bool('nssm.classic_rainbow_staff')

-- Server safe setting - fire-placing mobs do not cause havoc on server
nssm.normal_fire = minetest.settings:get_bool('nssm.normal_fire')

-- Safe fire
nssm.fire_node = "nssm:squib_fire"
if nssm.normal_fire then
    nssm.fire_node = "fire:basic_flame"
end
