local Class = require'libs.hump.class'

local Entity = Class{}

function Entity:init(--[[world,--]]x,y,w,h)
    -- self.world = world
    self.x = x
    self.y = y
    self.w = w
    self.h = h

    self.name = 'Entity'
    self.collisions = {}
    self.friction = 0

    -- an entity has a good chance of having a hitbox
    self.hitBox = nil
    -- singular attack
    self.attackHitBox = nil
    -- mutliple attacks ? todo fixme
    -- i don't know about this yet
    self.attackHitBoxes = nil
end

function Entity:handleCollisions(collisions, dt)
    if #collisions == 0 then
        self.onGround = false
        return
    end
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

function Entity:getCollisionFilter(item, other)
    return 'slide'
end

return Entity
