-- arduplane_osd.lua
-- ArduPlane-style OSD für das Flugzeug ca320t.acf

-- Skript nur für das Flugzeug ca320t.acf ausführen
if AIRCRAFT_FILENAME ~= "ca320t.acf" then return end

-- Wechsle beim Start direkt in den FPV-Modus (Forward with nothing)
command_once("sim/view/forward_with_nothing")

-- DataRefs einbinden
DataRef("osd_pitch", "sim/flightmodel/position/theta", "readonly")
DataRef("osd_roll", "sim/flightmodel/position/phi", "readonly")
DataRef("osd_vsi", "sim/flightmodel/position/vh_ind_fpm", "readonly")
DataRef("osd_alt", "sim/flightmodel/position/elevation", "readonly") -- Höhe in Metern
DataRef("osd_gs", "sim/flightmodel/position/groundspeed", "readonly") -- Groundspeed in m/s
DataRef("osd_throttle", "sim/cockpit2/engine/actuators/throttle_ratio_all", "readonly") -- Throttle als 0.0 bis 1.0
DataRef("osd_volts", "sim/cockpit2/electrical/battery_voltage_indicated_volts", "readonly", 0)
DataRef("osd_amps", "sim/cockpit2/electrical/battery_amps", "readonly", 0)
DataRef("SIM_PERIOD", "sim/operation/misc/frame_rate_period", "readonly") -- Sekunden pro Frame
DataRef("osd_heading", "sim/flightmodel/position/magpsi", "readonly") -- Magnetischer Kompass
DataRef("osd_view_is_external", "sim/graphics/view/view_is_external", "readonly") -- 0 = intern, >0 = extern

-- Lokale Variablen für das OSD
local consumed_mah = 0
local sats = math.random(8, 15)
local last_sat_update = 0

-- Update Logik (für Batterie und Satelliten), läuft jeden Frame
function update_arduplane_osd()
    -- SIM_PERIOD ist die Dauer des aktuellen Frames in Sekunden
    -- Amperemeter-Wert absolut nehmen (Stromfluss)
    local current_amps = math.abs(osd_amps)
    
    -- Umrechnung: Ah = Amps * Stunden. mAh = Ah * 1000. 
    -- Stunden = SIM_PERIOD / 3600
    consumed_mah = consumed_mah + (current_amps * 1000 * (SIM_PERIOD / 3600))
    
    -- Satellitenanzahl gelegentlich variieren, damit es "lebt"
    if os.clock() - last_sat_update > 15 then
        sats = math.random(8, 15)
        last_sat_update = os.clock()
    end
end

-- Lokale Hilfsfunktion fuer blockige OSD-Schrift mit schwarzer Outline
local OSD_FONT = "Helvetica_18"

local function draw_osd_text(x, y, text)
    local tracking = 1
    local cursor_x = x
    local outline_offsets = {
        {-3, 0}, {3, 0}, {0, -3}, {0, 3},
        {-2, 0}, {2, 0}, {0, -2}, {0, 2},
        {-2, -1}, {-2, 1}, {2, -1}, {2, 1},
        {-1, -2}, {1, -2}, {-1, 2}, {1, 2},
        {-1, -1}, {-1, 1}, {1, -1}, {1, 1}
    }
    local fill_offsets = {
        {0, 0}, {1, 0}, {-1, 0}, {0, 1}, {0, -1}
    }

    -- Zeichen einzeln zeichnen, damit zwischen Glyphen mehr Abstand entsteht.
    for i = 1, #text do
        local ch = string.sub(text, i, i)
        local ch_width = measure_string(ch, OSD_FONT)

        -- Duenne schwarze Kontur fuer bessere Lesbarkeit auf hellem Hintergrund
        graphics.set_color(0, 0, 0, 1)
        for _, offset in ipairs(outline_offsets) do
            draw_string_Helvetica_18(cursor_x + offset[1], y + offset[2], ch)
        end

        -- Weisser Kern mit etwas mehr Flaeche
        graphics.set_color(1, 1, 1, 1)
        for _, offset in ipairs(fill_offsets) do
            draw_string_Helvetica_18(cursor_x + offset[1], y + offset[2], ch)
        end

        cursor_x = cursor_x + ch_width + tracking
    end
end

-- Zeichen Logik für das OSD
function draw_arduplane_osd()
    -- OSD nur in interner Sicht anzeigen.
    if osd_view_is_external > 0 then return end

    -- Optional: Zeichne nur im 2D/HUD-Modus, falls das gewünscht ist.
    -- X-Plane rendert das so oder so als Overlay, wenn das Skript läuft.

    local cx = SCREEN_WIDTH / 2
    local cy = SCREEN_HEIGHT / 2
    
    -- OSD Farbe auf Weiß setzen
    graphics.set_color(1, 1, 1, 1)
    
    -- --- Compass Bar (Oben Mitte) ---
    local comp_y = SCREEN_HEIGHT - 60
    local fov_deg = 90 -- Anzeigebereich in Grad auf der Bar
    local comp_width = 250 -- Breite des Kompass in Pixeln
    
    -- Zentrums-Marker zeichnen (wie ein statisches Visier)
    draw_osd_text(cx - 5, comp_y - 15, "v")
    
    local start_deg = math.floor((osd_heading - fov_deg/2) / 10) * 10
    local end_deg = math.floor((osd_heading + fov_deg/2) / 10) * 10
    
    for d = start_deg, end_deg, 10 do
        local diff = d - osd_heading
        local px = cx + (diff / (fov_deg / 2)) * (comp_width / 2)
        
        -- Wrap-Around für die Buchstaben
        local display_d = d % 360
        if display_d < 0 then display_d = display_d + 360 end
        
        local symbol = "|" -- Default: Strich für eine 10-Grad-Markierung
        if display_d == 0 then symbol = "N"
        elseif display_d == 90 then symbol = "E"
        elseif display_d == 180 then symbol = "S"
        elseif display_d == 270 then symbol = "W"
        end
        
        -- Text zentrieren (Helvetica 18 ist je nach Buchstabe ca 10-12px breit)
        draw_osd_text(px - 5, comp_y, symbol)
    end
    
    -- --- Anzeigen an den Rändern ---
    
    -- Oben Links: GPS Geschwindigkeit in km/h (m/s * 3.6)
    local speed_kmh = osd_gs * 3.6
    draw_osd_text(50, SCREEN_HEIGHT - 60, string.format("GS  %0.0f km/h", speed_kmh))
    
    -- Oben Rechts: Höhe in Metern
    draw_osd_text(SCREEN_WIDTH - 200, SCREEN_HEIGHT - 60, string.format("ALT  %0.0f m", osd_alt))
    
    -- Unten Links: Satelliten
    draw_osd_text(50, 60, string.format("SATS  %d", sats))
    
    -- Unten Rechts: 4S Batterie und verbrauchte mAh
    -- Da das Flugzeug in X-Plane intern scheinbar mit >23V läuft, 
    -- skalieren wir den echten Batteriewert passend auf einen 4S LiPo.
    local display_volts = (osd_volts / 23.3) * 16.5 -- (als kleine Rechengrundlage, max 16.8V)
    if display_volts > 16.8 then display_volts = 16.8 end
    
    draw_osd_text(SCREEN_WIDTH - 300, 80, string.format("THR   %0.0f%%", (osd_throttle or 0) * 100))
    draw_osd_text(SCREEN_WIDTH - 300, 60, string.format("BATT  %0.1fV  %0.0f mAh", display_volts, consumed_mah))
    
    -- Mitte Rechts: Vertical Speed in m/s
    local vs_ms = osd_vsi * 0.00508 -- 1 fpm = 0.00508 m/s
    draw_osd_text(SCREEN_WIDTH - 200, cy, string.format("VS  %0.1f m/s", vs_ms))
    
    
    -- --- Künstlicher Horizont (Mitte) ---
    
    -- Statisches Fadenkreuz Mitte (- O -) im ArduPilot/Pixhawk Stil
    graphics.set_color(0, 0, 0, 1) -- Schwarze Outline
    graphics.draw_rectangle(cx - 32, cy - 3, cx - 8, cy + 3)
    graphics.draw_rectangle(cx + 8, cy - 3, cx + 32, cy + 3)
    graphics.draw_rectangle(cx - 5, cy - 5, cx + 5, cy + 5)
    
    graphics.set_color(1, 1, 1, 1) -- Weiß Innen
    graphics.draw_rectangle(cx - 30, cy - 1, cx - 10, cy + 1)
    graphics.draw_rectangle(cx + 10, cy - 1, cx + 30, cy + 1)
    graphics.draw_rectangle(cx - 3, cy - 3, cx + 3, cy + 3)
    
    -- Bewegliche Horizontlinie berechnen
    -- Pitch (Nase hoch = positiv) -> Horizont verschiebt sich nach unten
    local pitch_offset = osd_pitch * 8 
    local horizon_y = cy - pitch_offset
    
    -- Rollrad in Radianten berechnen
    -- Der Winkel muss positiv zu osd_roll übertragen werden. 
    -- Ist der Roll z.B. 45° rechts, so neigt sich das HUD parallel zum echten Horizont
    -- korrekterweise mit dem Flugzeugausgleich mit (+ Winkel). 
    -- Vorherige Falschberechnungen/Invertierungen oder halbe Rotationen entfallen hier.
    local rad = math.rad(osd_roll)
    local cos_a = math.cos(rad)
    local sin_a = math.sin(rad)
    
    -- Fette "Dots" (als kleine Rechtecke) zeichnen statt einer durchgehenden Linie
    -- Eine Serie von Offset-Distanzen vom Zentrum
    local offsets = {-160, -120, -80, 80, 120, 160}
    
    for _, dist in ipairs(offsets) do
        local dx = cx + (cos_a * dist)
        local dy = horizon_y + (sin_a * dist)
        
        -- Schwarze Outline
        graphics.set_color(0, 0, 0, 1)
        graphics.draw_rectangle(dx - 5, dy - 5, dx + 5, dy + 5)
        
        -- Weiß Innen
        graphics.set_color(1, 1, 1, 1)
        graphics.draw_rectangle(dx - 3, dy - 3, dx + 3, dy + 3)
    end
end

-- Funktionen am FlyWithLua-Zyklus registrieren
do_every_frame("update_arduplane_osd()")
do_every_draw("draw_arduplane_osd()")
