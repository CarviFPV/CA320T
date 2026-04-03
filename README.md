# CA320T - X-Plane 12 Sub-250 Twin-Motor Tailsitter

This repository contains the X-Plane 12 flight model of the **CA320T**, a compact FPV tailsitter wing based on the real CarviFPV concept.

The simulated aircraft is designed around these key characteristics:

- **Class:** Sub-250 g FPV bi-motor tailsitter wing
- **Wingspan:** 32 cm
- **Power-to-weight:** approximately **4:1 thrust-to-weight**
- **Primary use case:** VTOL tailsitter simulation and control testing

## Project Goal

The purpose of this model is to simulate the real **CA320T** platform as closely as possible in X-Plane 12.  
The real-world CA320T design will be available **exclusively on Makerworld.com**.

This simulation environment is especially useful for:

- transition training (hover to forward flight and back)
- control allocation validation for dual-motor tailsitters
- mission logic checks before real-world flights
- PID and navigation behavior tuning in a safe environment

## Important: Full Functionality Requires ArduPilot SITL

You can load and fly the aircraft in X-Plane directly, but to use the **full feature set** it should be operated together with:

- **ArduPilot SITL**
- **Mission Planner**

In this setup, X-Plane acts as the physics and visual simulator, while ArduPilot SITL provides the autopilot logic exactly as in real operations.

## Repository Structure

Main folders used in this project:

- `X-Plane12/ca320t/` - aircraft model files for X-Plane 12
- `X-Plane12/Ardupilot/xplane_plane.json` - ArduPilot interface mapping/config
- `X-Plane12/Lua/` - helper scripts (logging, startup, utility functions)

## Requirements

To run the complete workflow you typically need:

1. X-Plane 12
2. ArduPilot SITL (latest stable or development build)
3. Mission Planner (Windows)
4. Proper SITL-to-X-Plane bridge configuration

## Quick Start

1. Place the `ca320t` aircraft folder into your X-Plane 12 aircraft directory.
2. Ensure the ArduPilot mapping file (`xplane_plane.json`) is available for your SITL setup.
3. Start ArduPilot SITL with tailsitter-capable firmware/settings.
4. Open Mission Planner and connect to SITL.
5. Start X-Plane and load the CA320T model.
6. Verify control surfaces/motor outputs and direction before arming.
7. Perform hover, transition, and fixed-wing tests in a safe virtual environment.

## Recommended Simulation Workflow

For best results, use this order for each test session:

1. **Sensor and frame check**  
	Confirm expected orientation, frame type, and control output mapping.
2. **Hover validation**  
	Test stable vertical behavior and attitude response.
3. **Transition envelope expansion**  
	Gradually increase transition speed and angle targets.
4. **Forward-flight tuning**  
	Validate roll/pitch/yaw authority and tracking behavior.
5. **Autonomous mission validation**  
	Run planned mission segments in SITL before real deployment.

## Notes on Aircraft Behavior

Because the CA320T has high thrust relative to mass, expect:

- very aggressive acceleration response
- fast attitude changes from small control inputs
- increased sensitivity during transition phases

Start with conservative gains and gradually tune for your desired handling qualities.

## Included Lua Scripts

The `X-Plane12/Lua/` directory includes helper scripts for logging and session utilities.  
Depending on your plugin setup (for example FlyWithLua), these can support repeatable testing and diagnostics.

## Current Status

This repository is focused on simulation and iterative development.  
Parameters, mappings, and tuning values may evolve as the real CA320T platform is finalized.

## Troubleshooting

If behavior looks wrong, check the following first:

- axis and orientation mapping between SITL and X-Plane
- motor direction and output assignment
- frame configuration and tailsitter-specific parameters
- communication link status between SITL and Mission Planner
- Lua/plugin environment loading correctly

## Disclaimer

This project is for simulation, testing, and educational use.  
Any transfer of tuning values from simulation to real hardware must be validated carefully and safely.

---

If you are preparing for real CA320T operations, use this model to validate transitions, mission logic, and failure-handling scenarios before first physical flights.

## Log Export for UAVDesk

The scripts `flylog.lua` and `tellog.lua` create a `LOG` folder in the X-Plane root directory.
This folder stores telemetry data and flight times for each flight session.

The generated logs can be imported directly into **[uavdesk.app](https://uavdesk.app)**.
