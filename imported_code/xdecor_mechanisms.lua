--[[
┌──────────────────────────────────────────────────────────────────────┐
│   Copyright (c) 2015-2017 kilbith <jeanpatrick.guerrero@gmail.com>   │
│                                                                      │
│   Code: BSD                                                          │
│                                                                      │
│   Textures: WTFPL (credits: Gambit, kilbith, Cisoun)                 │

    │   (not imported) Sounds:                                             │
    │     - xdecor_boiling_water.ogg - by Audionautics - CC BY-SA          │
    │           freesound.org/people/Audionautics/sounds/133901/           │
    │     - xdecor_enchanting.ogg - by Timbre - CC BY-SA-NC                │
    │          freesound.org/people/Timbre/sounds/221683/                  │
    │     - xdecor_bouncy.ogg - by Blender Foundation - CC BY 3.0          │
    │           opengameart.org/content/funny-comic-cartoon-bounce-sound   │

└──────────────────────────────────────────────────────────────────────┘


Copyright (c) 1998, Regents of the University of California
All rights reserved.
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.
* Neither the name of the University of California, Berkeley nor the
  names of its contributors may be used to endorse or promote products
  derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--]]

if minetest.get_modpath("xdecor") then
    return
end

-- Thanks to sofar for helping with that code.

minetest.setting_set("nodetimer_interval", 0.1)

local plate = {}
screwdriver = screwdriver or {}

local function pixelbox(size, boxes)
    local fixed = {}
    for _, box in pairs(boxes) do
        -- `unpack` has been changed to `table.unpack` in newest Lua versions.
        local x, y, z, w, h, l = unpack(box)
        fixed[#fixed+1] = {
            (x / size) - 0.5,
            (y / size) - 0.5,
            (z / size) - 0.5,
            ((x + w) / size) - 0.5,
            ((y + h) / size) - 0.5,
            ((z + l) / size) - 0.5
        }
    end
    return {type="fixed", fixed=fixed}
end

local function door_toggle(pos_actuator, pos_door, player)
    local player_name = player:get_player_name()
    local actuator = minetest.get_node(pos_actuator)
    local door = doors.get(pos_door)

    if actuator.name:sub(-4) == "_off" then
        minetest.set_node(pos_actuator,
            {name=actuator.name:gsub("_off", "_on"), param2=actuator.param2})
    end
    door:open(player)

    minetest.after(2, function()
        if minetest.get_node(pos_actuator).name:sub(-3) == "_on" then
            minetest.set_node(pos_actuator,
                {name=actuator.name, param2=actuator.param2})
        end
        -- Re-get player object (or nil) because 'player' could
        -- be an invalid object at this time (player left)
        door:close(minetest.get_player_by_name(player_name))
    end)
end

-- Plates

function plate.construct(pos)
    local timer = minetest.get_node_timer(pos)
    timer:start(0.1)
end

function plate.timer(pos)
    local objs = minetest.get_objects_inside_radius(pos, 0.8)
    if not next(objs) or not doors.get then return true end
    local minp = {x=pos.x-2, y=pos.y, z=pos.z-2}
    local maxp = {x=pos.x+2, y=pos.y, z=pos.z+2}
    local doors = minetest.find_nodes_in_area(minp, maxp, "group:door")

    for _, player in pairs(objs) do
        if player:is_player() then
            for i=1, #doors do
                door_toggle(pos, doors[i], player)
            end
            break
        end
    end
    return true
end

function plate.register(material, desc, def)
    minetest.register_node("nssm:pressure_"..material.."_off", {
        description = desc.." Pressure Plate",
        tiles = {"xdecor_pressure_"..material..".png"},
        drawtype = "nodebox",
        node_box = pixelbox(16, {{1, 0, 1, 14, 1, 14}}),
        groups = def.groups,
        sounds = def.sounds,
        sunlight_propagates = true,
        on_rotate = screwdriver.rotate_simple,
        on_construct = plate.construct,
        on_timer = plate.timer
    })
    minetest.register_node("nssm:pressure_"..material.."_on", {
        tiles = {"xdecor_pressure_"..material..".png"},
        drawtype = "nodebox",
        node_box = pixelbox(16, {{1, 0, 1, 14, 0.4, 14}}),
        groups = def.groups,
        sounds = def.sounds,
        drop = "nssm:pressure_"..material.."_off",
        sunlight_propagates = true,
        on_rotate = screwdriver.rotate_simple
    })
    minetest.register_craft({
        output = "nssm:pressure_"..material.."_off",
        type = "shapeless",
        recipe = {"group:"..material, "group:"..material}
    })
end

plate.register("wood", "Wooden", {
    sounds = default.node_sound_wood_defaults(),
    groups = {choppy=3, oddly_breakable_by_hand=2, flammable=2}
})

plate.register("stone", "Stone", {
    sounds = default.node_sound_stone_defaults(),
    groups = {cracky=3, oddly_breakable_by_hand=2}
})

-- Lever

minetest.register_node("nssm:lever_off", {
    description = "Lever",
    tiles = {"xdecor_lever_off.png"},
    drawtype = "nodebox",
    node_box = pixelbox(16, {{2, 1, 15, 12, 14, 1}}),
    groups = {cracky=3, oddly_breakable_by_hand=2},
    sounds = default.node_sound_stone_defaults(),
    sunlight_propagates = true,
    on_rotate = screwdriver.rotate_simple,
    paramtype2 = "facedir",
    on_rightclick = function(pos, node, clicker, itemstack)
        if not doors.get then return itemstack end
        local minp = {x=pos.x-2, y=pos.y-1, z=pos.z-2}
        local maxp = {x=pos.x+2, y=pos.y+1, z=pos.z+2}
        local doors = minetest.find_nodes_in_area(minp, maxp, "group:door")

        for i=1, #doors do
            door_toggle(pos, doors[i], clicker)
        end
        return itemstack
    end
})

minetest.register_node("nssm:lever_on", {
    tiles = {"xdecor_lever_on.png"},
    drawtype = "nodebox",
    node_box = pixelbox(16, {{2, 1, 15, 12, 14, 1}}),
    groups = {cracky=3, oddly_breakable_by_hand=2, not_in_creative_inventory=1},
    sounds = default.node_sound_stone_defaults(),
    sunlight_propagates = true,
    on_rotate = screwdriver.rotate_simple,
    drop = "nssm:lever_off"
})

minetest.register_craft({
    output = "nssm:lever_off",
    recipe = {
        {"group:stick"},
        {"group:stone"}
    }
})


