local step_timer = 0

-- Code and sounds taken from PilzAdam's `item_drop` mod (WTFPL)
-- https://github.com/PilzAdam/item_drop
-- Hereby re-licensed under LGPL v2.1 or later

-- Ostensibly for testing for now
-- Entities do not move within the expected radius

if not minetest.get_modpath("itemdrop") then
    minetest.register_globalstep(function(dtime)
        step_timer = step_timer + dtime
        if step_timer >= 0.2 then
            step_timer = 0
        else
            return
        end

        for _,player in ipairs(minetest.get_connected_players()) do
            local pos = player:getpos()
            pos.y = pos.y+0.5
            local inv = player:get_inventory()
            
            for _,object in ipairs(minetest.env:get_objects_inside_radius(pos, 1)) do
                if not object:is_player() and object:get_luaentity() and object:get_luaentity().name == "__builtin:item" then
                    if inv and inv:room_for_item("main", ItemStack(object:get_luaentity().itemstring)) then
                        inv:add_item("main", ItemStack(object:get_luaentity().itemstring))
                        if object:get_luaentity().itemstring ~= "" then
                            minetest.sound_play("item_drop_pickup", {
                                to_player = player:get_player_name(),
                                gain = 0.4,
                            })
                        end
                        object:get_luaentity().itemstring = ""
                        object:remove()
                    end
                end
            end
            
            for _,object in ipairs(minetest.env:get_objects_inside_radius(pos, 3)) do
                if not object:is_player() and object:get_luaentity() and object:get_luaentity().name == "__builtin:item" then
                    if inv and inv:room_for_item("main", ItemStack(object:get_luaentity().itemstring)) then
                        local pos1 = pos
                        pos1.y = pos1.y+0.2
                        local pos2 = object:getpos()
                        local vec = {x=pos1.x-pos2.x, y=pos1.y-pos2.y, z=pos1.z-pos2.z}
                        
                        vec.x = vec.x*10
                        vec.y = vec.y*10
                        vec.z = vec.z*10

                        object:get_luaentity().collide_with_objects = false
                        object:get_luaentity().object:set_properties({
                            physical = false,
                            collide_with_objects = false,
                            weight = 0,
                        })
                        object:setvelocity(vec)
                        
                        minetest.after(1,function(args)
                            local lua = object:get_luaentity()

                            if object == nil or lua == nil or lua.itemstring == nil then
                                -- Someone picked it up in the meantime
                                return
                            end

                            if inv:room_for_item("main", ItemStack(object:get_luaentity().itemstring)) then
                                inv:add_item("main", ItemStack(object:get_luaentity().itemstring))
                                if object:get_luaentity().itemstring ~= "" then
                                    minetest.sound_play("item_drop_pickup", {
                                        to_player = player:get_player_name(),
                                        gain = 0.4,
                                    })
                                end
                                object:get_luaentity().itemstring = ""
                                object:remove()
                            else
                                object:setvelocity({x=0,y=0,z=0})
                                object:get_luaentity().collide_with_objects = true
                                object:get_luaentity().object:set_properties({
                                    physical = true,
                                    collide_with_objects = false,
                                    weight = 1,
                                })
                            end
                        end, {player, object})
                        
                    end
                end
            end
        end
    end)
end
