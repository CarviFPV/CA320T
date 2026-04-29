# CA320T Tailsitter for X-Plane 11

This repository contains the CA320T tailsitter model for X-Plane 11.

## CarviLabs

For product details and current updates, see the CarviLabs product page:
https://carvilabs.com/products/carvisim/ca320t-x-plane

If you want to run the setup with Mission Planner, follow this guide:
https://carvilabs.com/products/carvisim/ca320t-x-plane/wiki/sitl-mission-planner-configuration

## Installation

Copy the content of `X-Plane11` into your X-Plane 11 root folder.

After copying, start X-Plane 11, select the CA320T aircraft, and fly.

## Recommended Control Setup

If you have an RC transmitter, it is recommended to connect it and use it as a joystick in X-Plane.
This usually gives a much more realistic control feel for a tailsitter.

## Included FlyWithLua Scripts

The FlyWithLua script folder includes the following helper scripts.

- `arduplane_osd.lua`
  Shows an ArduPlane-style FPV OSD overlay (compass bar, speed, altitude, vertical speed, battery estimate, horizon helper).

- `disable_redout.lua`
  Disables redout/blackout (G-force dimming) effects.

- `flylog.lua`
  Logs arming/disarming events and flight duration to `LOGS/flylog.csv` for later analysis in https://uavdesk.app.

- `tellog.lua`
  Records telemetry data (GPS, altitude, speed, attitude, and control inputs) to CSV files in the `LOGS` folder, which can be imported into https://uavdesk.app.

## Notes

- Most scripts are intended for `ca320t.acf`.
- If needed, you can adjust script values to fit your controller and flying style.