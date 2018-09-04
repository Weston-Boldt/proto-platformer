local Entity = require'../entity'
local Class = require'../libs.hump.class'

HitBox = Class {
}

function HitBox:init(obj,x,y,w,h)
    self.name = "HitBox"
    self.collType = "slide" -- default
    self.obj = obj
    self.x = x
    self.y = y
    self.w = w
    self.h = h

    self.img = love.graphics.newImage(
        'assets/entity_stub.png'
    )
    return self
end


function HitBox:detach()
    -- print("calling detach")
    -- print("self = "..tostring(self))
    -- print("self.obj = "..tostring(self.obj))
    self.obj = false
    -- print("after self.obj = "..tostring(self.obj))
end

function HitBox:update(xPos,yPos,dt)
    local targetX = nil;
    local targetY = nil;
    if not xPos then
        targetX = self.obj.x
    else 
        targetX = xPos
    end
    if not yPos then
        targetY = self.obj.y
    else 
        targetY = yPos
    end
    self.x = targetX
    self.y = targetY
end

function HitBox:handleCollisions(collisions,dt)
    for key, value in pairs(collisions) do
        --print(key)
    end
end

function HitBox:draw()
    lg.draw(self.img, math.floor(self.x), math.floor(self.y))
end

function HitBox:getCollisionFilter(item, other)
    return 'slide'
end

return HitBox
