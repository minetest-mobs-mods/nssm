nssm.mymapgenis = tonumber(minetest.settings:get('nssm.mymapgenis')) or 7
nssm.multimobs = tonumber(minetest.settings:get('nssm.multimobs')) or 1000

-- Server safe setting - allow a non-griefing rainbow tool
nssm.init_rainbow_staff = minetest.settings:get_bool('nssm.classic_rainbow_staff', false)

minetest.debug( dump(nssm) )
