local Entity = require'../entity'
local Class = require'../libs.hump.class'

HitBox = Class {
    objType = 'HitBox'
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

    -- don't want to attack something you've
    -- already attacked with a attack hitbox
    self.attackedObjects = {}
    
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

function HitBox:addAttack(hbox)
    -- print('hbox'..tostring(hbox))
    if inTable(hbox.obj, self.attackedObjects) then
        -- print('already had attacked this hitbox')
        return;
    end
    local attack = {
        attacker = self.obj, 
        target = hbox.obj
    }
    table.insert(
        self.obj.attacks,
        attack
    )

    table.insert(
        self.attackedObjects,
        hbox.obj
    )
end

function HitBox:handleCollision(hbox, dt)
    if hbox.obj.name == self.obj.name then
        return
        --[[
        if self.attack then
            return
        end
        --]]
    end
    --[[
    print('hbox.obj.name = '..tostring(hbox.obj.name))
    print('self.obj.name = '..tostring(self.obj.name))
    print('self.attack = '..tostring(self.attack))
    --]]
    if self.attack and hbox.obj.objType == 'Entity' then
        -- is the hitbox an entity 'attacking'
        -- another entity?
        -- print('hbox'..tostring(hbox))
        self:addAttack(hbox)
    end
end

function HitBox:handleCollisions(collisions,dt)
    if (self.attack) then
    end
    for index, coll in ipairs(collisions) do
        local obj =  coll.other
        self:handleCollision(obj,dt)
    end
end

function HitBox:draw()
    lg.draw(self.img, math.floor(self.x), math.floor(self.y))
end

function HitBox:getCollisionFilter(item, other)
    --[[
    for key, value in pairs(other) do
        print(tostring(key).." = "..tostring(value))
    end
    --]]
    --[[
    if item.obj.name == self.obj.name then
        return 'cross'
    end
    --]]
    return 'cross'
end

return HitBox
