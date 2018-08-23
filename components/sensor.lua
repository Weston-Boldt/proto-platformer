local Class = require'../libs.hump.class'
-- not in the bump world
-- so it doesn't need a collType
-- just for dirtyRect overlap for entities
local Sensor = Class {
}

function Sensor:init(x,y,w,h,map)
    self.name = "Sensor"
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.map = map
    self.img = love.graphics.newImage(
        'assets/sensor_stub.png'
    )
end

function Sensor:update(x, y, dt) 
    self.x = x
    self.y = y
end

function Sensor:draw()
    lg.draw(self.img, math.floor(self.x), math.floor(self.y))
end

return Sensor
