-- not in the bump world
-- so it doesn't need a collType
-- just for dirtyRect overlap for entities
local Sensor = {}

function Sector:init()
    self.name = "Sensor"
end
return Sensor
