-- tailsitter_start.lua
-- Rotiert das Flugzeug beim Start um 90 Grad (Nase nach oben)
-- Setzt es um 1 Fuß (ca. 0.3048 Meter) höher
-- Wechselt automatisch in die Außenansicht

-- Nur für bestimmtes Flugzeug ausführen
if AIRCRAFT_FILENAME ~= "ca320t.acf" then return end

-- DataRefs für Position und Ausrichtung (Quaternion) definieren
DataRef("local_y", "sim/flightmodel/position/local_y", "writable")
DataRef("q_quat_0", "sim/flightmodel/position/q", "writable", 0)
DataRef("q_quat_1", "sim/flightmodel/position/q", "writable", 1)
DataRef("q_quat_2", "sim/flightmodel/position/q", "writable", 2)
DataRef("q_quat_3", "sim/flightmodel/position/q", "writable", 3)

DataRef("throttle", "sim/flightmodel/engine/ENGN_thro", "readonly", 0)

local tailsitter_initialized = false
local tailsitter_finished = false
local saved_local_y = 0

function hold_tailsitter()
    if tailsitter_finished then return end

    if throttle >= 0.95 then
        tailsitter_finished = true
        return
    end

    -- Initialize things like external view and slight lift only once
    if not tailsitter_initialized then
        saved_local_y = local_y + 300
        local_y = saved_local_y
        command_once("sim/view/chase")
        tailsitter_initialized = true
    end

    -- Hold the plane vertical
    q_quat_0 = 0.70710678
    q_quat_1 = 0.0
    q_quat_2 = 0.70710678
    q_quat_3 = 0.0
    local_y = saved_local_y
end

-- Using do_every_frame to override physics engine every frame while standing
do_every_frame("hold_tailsitter()")

-- Command to manually reset the state if needed
create_command("FlyWithLua/Tailsitter/ResetToVertical", 
               "Setzt das Tailsitter-Flugzeug aufrecht", 
               "tailsitter_initialized = false; tailsitter_finished = false", 
               "", "")
