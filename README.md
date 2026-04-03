# CA320T — CarviFPV 320 Tailsitter

This repository contains the **X-Plane flight simulator model** of the **CarviFPV 320 Tailsitter (CA320T)**, an FPV Sub-250 g tailsitter VTOL aircraft powered by **ArduPilot**.

---

## About the CA320T

The CA320T is a compact, sub-250 g FPV tailsitter designed and built by CarviFPV.  
It takes off and lands vertically like a multirotor, then transitions to efficient forward flight — all managed autonomously by ArduPilot.

Key features:

- **Sub-250 g** — keeps it in the lightest regulatory class in most countries
- **Tailsitter VTOL** — vertical take-off and landing, fixed-wing forward flight
- **FPV** — first-person-view capable
- **ArduPilot** — open-source flight stack with full autonomous capability

---

## Repository Structure

```
CA320T/
├── xplane11/          # X-Plane 11 aircraft model files
├── xplane12/          # X-Plane 12 aircraft model files
├── ardupilot/         # ArduPilot parameter files for the real-life model
└── README.md
```

### X-Plane 11 Model (`xplane11/`)

Aircraft model files for use with **X-Plane 11**.  
Copy the contents of this folder into your X-Plane 11 `Aircraft/` directory.

### X-Plane 12 Model (`xplane12/`)

Aircraft model files for use with **X-Plane 12**.  
Copy the contents of this folder into your X-Plane 12 `Aircraft/` directory.

### ArduPilot Parameters (`ardupilot/`)

The `.param` configuration files for the real-life CA320T hardware are stored here.  
These are used to configure ArduPilot on the physical model.

> **Hardware files and build instructions** are hosted exclusively on **[MakerWorld](https://makerworld.com/)**.  
> Search for **CA320T by CarviFPV** to find the printable parts and assembly guide.

---

## Installation

### X-Plane (Simulator)

1. Clone or download this repository.
2. Copy the appropriate model folder (`xplane11/` or `xplane12/`) into your X-Plane `Aircraft/` directory.
3. Launch X-Plane and select the **CA320T** from the aircraft menu.

### ArduPilot (Real-Life Model)

1. Build the CA320T hardware using the files on [MakerWorld](https://makerworld.com/) (search *CA320T CarviFPV*).
2. Flash your flight controller with the latest ArduPilot firmware.
3. Load the `.param` file from the `ardupilot/` folder using **Mission Planner** or **QGroundControl**.

---

## Flight Log Upload — Share Your Logs with Us!

If you fly the CA320T in X-Plane with **FlyWithLua** and have the following Lua scripts installed:

- `flylog.lua`
- `tellelog.lua`

your flight logs are automatically saved to the **`LOGS/`** folder in the root of your X-Plane installation (e.g. `X-Plane 12/LOGS/`).

### 📤 Upload Your Flight Logs

We'd love to see your flights! Please upload your log files to our support portal:

👉 **[https://uvadesk.app](https://uvadesk.app)**

1. Go to [https://uvadesk.app](https://uvadesk.app).
2. Open a new ticket or use the dedicated **Flight Log Upload** form.
3. Attach the log file(s) from your `LOGS/` folder.
4. Submit — we'll review and get back to you!

Your logs help us improve the flight model and ArduPilot parameter tuning.

---

## Contributing

Pull requests and issue reports are welcome!  
If you find a bug in the flight model or have improved parameters, feel free to open a PR or issue.

---

## License

See [LICENSE](LICENSE) for details.
