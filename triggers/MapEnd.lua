local Class = require'libs.hump.class'
-- local Trigger = require'../trigger'
local Trigger = require'trigger'

MapEnd = Class{
    __includes = Trigger
}

function MapEnd:init(x,y,w,h,properties,map)
    Trigger:init(self,x,y,w,h)
    self.name = "MapEnd"
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.map = map
    self.properties = properties
    self.img = love.graphics.newImage(
        'assets/entity_stub.png'
    )
    self.pressable = true

    self.active = false
    return self
end

function MapEnd:update(dt)
    if not active then
        return nil;
    end
end

--[[
function MapEnd:draw()
end
--]]
