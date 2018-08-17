local Class = require'libs.hump.class'
-- local Trigger = require'../trigger'
local Trigger = require'trigger'

MapEnd = Class{
    __includes = Trigger
}

function MapEnd:init(x,y,w,h)
    Trigger:init(self,x,y,w,h)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.img = love.graphics.newImage(
        'assets/entity_stub.png'
    )

    return self
end

function MapEnd:update(dt)
end

--[[
function MapEnd:draw()
end
--]]
