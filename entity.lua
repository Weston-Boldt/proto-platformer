local Class = require'libs.hump.class'

local Entity = Class{}

function Entity:init(--[[world,--]]x,y,w,h)
    -- self.world = world
    self.x = x
    self.y = y
    self.w = w
    self.h = h

    self.name = 'Entity'
end

function Entity:getRect()
    return self.x, self.y, self.w, self.h
end

function Entity:update(dt)
    -- does nothing but jic we call update on an object inherited by entity
end

function Entity:draw()
    -- does nothing but jic we call update on an object inherited by entity
end

function Entity:test()
    print("hello from entity class")
end

return Entity
