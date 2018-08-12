local Entity = require'../entity'
local Class = require'../libs.hump.class'

HitBox = Class {
    __includes = Entity
}

function HitBox:init(obj,x,y,w,h)
    Entity:init(self,x,y,w,h)
    self.obj = obj
    self.x = x
    self.y = y
    self.w = w
    self.h = h
end

function HitBox:update(dt)
    self.x = self.obj.x
    self.y = self.obj.y
    -- print("HitBox.x = "..tostring(self.x)..
    --    "HitBox.y = "..tostring(self.y))
end

function HitBox:draw()
end

return HitBox
