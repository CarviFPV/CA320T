# CA320T Tailsitter for X-Plane 11 and X-Plane 12

This repository contains both CA320T tailsitter models:

- one setup for X-Plane 11
- one setup for X-Plane 12

## Installation

Use the folder that matches your simulator version:

1. For X-Plane 11: copy the content of `X-Plane11` into your X-Plane 11 root folder.
2. For X-Plane 12: copy the content of `X-Plane12` into your X-Plane 12 root folder.

After copying, start X-Plane, select the CA320T aircraft, and fly.

## Recommended Control Setup

If you have an RC transmitter, it is recommended to connect it and use it as a joystick in X-Plane.
This usually gives a much more realistic control feel for a tailsitter.

## Included FlyWithLua Scripts

The FlyWithLua script folders include the following helper scripts.

### Common Scripts (X-Plane 11 and X-Plane 12)

- `arduplane_osd.lua`
  Shows an ArduPlane-style FPV OSD overlay (compass bar, speed, altitude, vertical speed, battery estimate, horizon helper).

- `disable_redout.lua`
  Disables redout/blackout (G-force dimming) effects.

- `flylog.lua`
  Logs arming/disarming events and flight duration to `LOGS/flylog.csv` for later analysis in https://uavdesk.app.

- `tellog.lua`
  Records telemetry data (GPS, altitude, speed, attitude, and control inputs) to CSV files in the `LOGS` folder, which can be imported into https://uavdesk.app.

### Additional Script in X-Plane 12

- `ca320t_pitch_roll_sensitivity.lua`
  Reduces pitch and roll input sensitivity to make manual control smoother.

## Notes

- Most scripts are intended for `ca320t.acf`.
- If needed, you can adjust script values to fit your controller and flying style.
