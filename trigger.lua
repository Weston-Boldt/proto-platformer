-- triggers are like entities cept they aren't
-- really physical in nature
-- keeping some of the boiler plate code anyways
-- just for semantic purposes
-- and also i don't want to inherit from 2 classes
-- even if its code duplication
local Class = require'libs.hump.class'

local Trigger = Class{}

function Trigger:init(x,y,w,h)
    self.x = x
    self.y = y
    self.w = w
    self.h = h

    self.img = love.graphics.newImage(
        'assets/entity_stub.png'
    )
    print("self.img = "..tostring(self.img))
end

function Trigger:getRect()
    return self.x, self.y, self.w, self.h
end

function Trigger:update(dt)
end

function Trigger:draw()
    lg.draw(self.img, math.floor(self.x), math.floor(self.y))
end

return Trigger
