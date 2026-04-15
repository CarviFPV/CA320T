local logs_dir = SYSTEM_DIRECTORY .. "LOGS"
local gpsTrackFile = nil
local lastLogTick = 0
local log_interval = 0.33 -- seconds (~3 Hz)
local logStart_ms = 0

-- Create LOGS directory if it doesn`t exist
os.execute('mkdir "' .. logs_dir .. '" > nul 2>&1')

DataRef("run_time", "sim/time/total_running_time_sec", "readonly")
DataRef("plane_lat", "sim/flightmodel/position/latitude", "readonly")
DataRef("plane_lon", "sim/flightmodel/position/longitude", "readonly")
DataRef("plane_alt", "sim/flightmodel/position/elevation", "readonly")
DataRef("plane_speed", "sim/flightmodel/position/groundspeed", "readonly")
DataRef("plane_course", "sim/flightmodel/position/hpath", "readonly")
DataRef("plane_vspeed", "sim/flightmodel/position/vh_ind_fpm", "readonly")

DataRef("plane_pitch", "sim/flightmodel/position/theta", "readonly")
DataRef("plane_roll", "sim/flightmodel/position/phi", "readonly")
DataRef("plane_yaw", "sim/flightmodel/position/psi", "readonly")

DataRef("plane_aileron", "sim/joystick/yoke_roll_ratio", "readonly")
DataRef("plane_elevator", "sim/joystick/yoke_pitch_ratio", "readonly")
DataRef("plane_throttle", "sim/cockpit2/engine/actuators/throttle_ratio_all", "readonly")
DataRef("plane_rudder", "sim/joystick/yoke_heading_ratio", "readonly")

function openGpsTrackFile()
    local timestamp = os.date("*t")
    local modelName = AIRCRAFT_FILENAME or "UnknownModel"
    modelName = string.gsub(modelName, "[^%w_%-]", "_")
    modelName = string.gsub(modelName, "_acf$", "") .. "_sim"
    
    local fname = string.format("%s/%s_TeleLog_%04d%02d%02d_%02d%02d%02d.csv",
        logs_dir, modelName,
        timestamp.year, timestamp.month, timestamp.day,
        timestamp.hour, timestamp.min, timestamp.sec)
        
    gpsTrackFile = io.open(fname, "w")
    if gpsTrackFile then
        gpsTrackFile:write("time,GPS_numSat,GPS_coord[0],GPS_coord[1],GPS_altitude,GPS_speed,GPS_ground_course,VSpd,Pitch,Roll,Yaw,RxBt,Curr,Capa,RQly,TQly,TPWR,Ail,Ele,Thr,Rud\n")
    end
end

function closeGpsTrackFile()
    if gpsTrackFile then
        gpsTrackFile:close()
        gpsTrackFile = nil
    end
end

function logGpsSample()
    if not gpsTrackFile then return end

    local time_us = ((run_time or 0) * 1000 - logStart_ms) * 100 -- Arbitrary timescale similar to EdgeTX
    
    local lat = plane_lat or 0
    local lon = plane_lon or 0
    local alt = plane_alt or 0
    local speed = plane_speed or 0
    local course = plane_course or 0
    local vSpeed = (plane_vspeed or 0) * 0.508 -- fpm to cm/s
    
    local pitch = math.rad(plane_pitch or 0) -- degrees to radians
    local roll = math.rad(plane_roll or 0)
    local yaw = math.rad(plane_yaw or 0)
    
    local rxBt = 0
    
    local curr = 0
    local capa = 0
    local rQly = 100
    local tQly = 100
    local tPwr = 100
    local numSat = 12
    
    local aileron = (plane_aileron or 0) * 1024
    local elevator = (plane_elevator or 0) * 1024
    local throttle = ((plane_throttle or 0) * 2048) - 1024 -- Map 0.0-1.0 to -1024-1024
    local rudder = (plane_rudder or 0) * 1024

    local line = string.format(
        "%d,%d,%.7f,%.7f,%d,%.2f,%.1f,%.2f,%.1f,%.1f,%.1f,%.2f,%.2f,%d,%d,%d,%d,%.2f,%.2f,%.2f,%.2f\n",
        math.floor(time_us), numSat, lat, lon, alt, speed, course, vSpeed, pitch, roll, yaw, rxBt, curr, capa, rQly, tQly, tPwr,
        aileron, elevator, throttle, rudder)
        
    gpsTrackFile:write(line)
    gpsTrackFile:flush()
end

function tellog_loop()
    if run_time == nil then return end
    
    local now = run_time
    if now - lastLogTick >= log_interval then
        logGpsSample()
        lastLogTick = now
    end
end

-- Initialize the logging
openGpsTrackFile()
if run_time ~= nil then
    lastLogTick = run_time
    logStart_ms = run_time * 1000
end

-- Hook into FlyWithLua callbacks
do_every_frame("tellog_loop()")
do_on_exit("closeGpsTrackFile()")
