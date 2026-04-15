-- disable_redout.lua
-- Deaktiviert Redout und Blackout (Greyout) Effekte bei hohen G-Kräften

-- Skript nur für das Flugzeug ca320t.acf ausführen
if AIRCRAFT_FILENAME ~= "ca320t.acf" then return end

-- Writable DataRef für die G-Force Effekte-Einstellung
DataRef("dim_gload", "sim/graphics/settings/dim_gload", "writable")

-- Effekt beim Laden des Flugzeugs deaktivieren
-- (0 = false/aus, 1 = true/an)
dim_gload = 0
