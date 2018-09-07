local Entity = require'../entity'
local Class = require'../libs.hump.class'

HitBox = Class {
}

function HitBox:init(obj,x,y,w,h,attack)
    self.name = "HitBox"
    self.collType = "slide" -- default
    self.obj = obj
    self.x = x
    self.y = y
    self.w = w
    self.h = h

    if not attack then
        self.attack = false
    else
        self.attack = attack
    end

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

function HitBox:handleCollision(obj, dt)
    for key, value in pairs(obj) do
        print(tostring(key).." = "..tostring(value))
        if obj.name == self.obj.name then
            return
            --[[
            if self.attack then
                return
            end
            --]]
        end
        if self.attack then
            -- fill out some attack info
            -- to be grabbed by the map class
        end
    end
end

function HitBox:handleCollisions(collisions,dt)
    for index, coll in ipairs(collisions) do
        local obj =  coll.other
        self:handleCollision(obj,dt)
    end
end

function HitBox:draw()
    lg.draw(self.img, math.floor(self.x), math.floor(self.y))
end

function HitBox:getCollisionFilter(item, other)
    return 'slide'
end

return HitBox
