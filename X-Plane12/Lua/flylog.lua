local logs_dir = SYSTEM_DIRECTORY .. "LOGS"
local log_file = logs_dir .. "/flylog.csv"
local flight_start_time = os.time()
local armed = false

-- Create LOGS directory if it doesn`t exist
os.execute('mkdir "' .. logs_dir .. '" > nul 2>&1')

DataRef("plane_lat", "sim/flightmodel/position/latitude", "readonly")
DataRef("plane_lon", "sim/flightmodel/position/longitude", "readonly")

local armingDetails = {}

local function init_flylog()
    local file = io.open(log_file, "r")
    if file then
        file:close()
    else
        file = io.open(log_file, "a")
        if file then
            file:write("Arming,Date,Timestamp-TO,GPS-Arming-Lat,GPS-Arming-Lon,Disarming,Timestamp-LDG,GPS-Disarming-Lat,GPS-Disarming-Lon,Duration,ModelName\n")
            file:close()
        end
    end
end

local function log_event(event, duration)
    local file = io.open(log_file, "a")
    if file then
        local timestamp = os.date("*t")
        local dateStr = string.format("%04d-%02d-%02d", timestamp.year, timestamp.month, timestamp.day)
        local timeStr = string.format("%02d:%02d:%02d", timestamp.hour, timestamp.min, timestamp.sec)
        local modelName = AIRCRAFT_FILENAME or "Unknown Model"
        modelName = string.gsub(modelName, "%.acf$", "") .. "_sim"
        local lat = plane_lat or 0
        local lon = plane_lon or 0

        if event == "Arming" then
            armingDetails = {
                event = event,
                dateStr = dateStr,
                timeStr = timeStr,
                modelName = modelName,
                gpsLat = lat,
                gpsLon = lon
            }
        elseif event == "Disarming" then
            local logLine = string.format("%s,%s,%s,%.6f,%.6f,%s,%s,%.6f,%.6f,%.2f,%s\n",
                armingDetails.event or "Arming",
                armingDetails.dateStr or dateStr,
                armingDetails.timeStr or timeStr,
                armingDetails.gpsLat or 0,
                armingDetails.gpsLon or 0,
                event,
                timeStr,
                lat,
                lon,
                duration or 0,
                armingDetails.modelName or modelName)
            file:write(logLine)
        end
        file:close()
    end
end

-- Initialize and log the start of the flight
init_flylog()
log_event("Arming", 0)
armed = true

-- Callback when exiting the flight or reloading scripts
function flylog_exit()
    if armed then
        local flightDuration = os.difftime(os.time(), flight_start_time)
        log_event("Disarming", flightDuration)
        armed = false
    end
end

do_on_exit("flylog_exit()")
