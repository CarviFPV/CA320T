-- ca320t_pitch_roll_sensitivity.lua
-- Reduces pitch and roll input sensitivity for ca320t.acf.

if AIRCRAFT_FILENAME ~= "ca320t.acf" then return end

-- Very strong damping: only 5% of raw pitch/roll input is applied.
local INPUT_SCALE = 0.05
-- Permanent small nose-up assist (always active each frame).
local PITCH_UP_BIAS = 0.01

DataRef("ca320t_override_joystick", "sim/operation/override/override_joystick", "writable")
DataRef("ca320t_yoke_pitch_ratio", "sim/joystick/yoke_pitch_ratio", "writable")
DataRef("ca320t_yoke_roll_ratio", "sim/joystick/yoke_roll_ratio", "writable")

DataRef("ca320t_pitch_input", "sim/joystick/joy_mapped_axis_value", "readonly", 1)
DataRef("ca320t_roll_input", "sim/joystick/joy_mapped_axis_value", "readonly", 2)

local function clamp(value, min_value, max_value)
    if value < min_value then return min_value end
    if value > max_value then return max_value end
    return value
end

function apply_ca320t_input_sensitivity()
    -- Override joystick processing so we can write filtered axis ratios.
    ca320t_override_joystick = 1

    ca320t_yoke_pitch_ratio = clamp(((ca320t_pitch_input or 0) * INPUT_SCALE) + PITCH_UP_BIAS, -1.0, 1.0)
    ca320t_yoke_roll_ratio = clamp((ca320t_roll_input or 0) * INPUT_SCALE, -1.0, 1.0)
end

do_every_frame("apply_ca320t_input_sensitivity()")
