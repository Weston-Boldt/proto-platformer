local Class = require'libs.hump.class'

-- this is probably unecessary
local ENTS_ACTIVE = 0

local Entity = Class{
    -- attacks on all entities
    -- even if ya don't need em
    attacks = {},
    objType = 'Entity',
    -- health = BASE_HEALTH,
    -- attackDamage = BASE_ATTACK
}

function Entity:init(--[[world,--]]x,y,w,h)
    -- self.world = world
    self.x = x
    self.y = y
    self.w = w
    self.h = h

    self.name = 'Entity'
    self.collisions = {}
    self.friction = 0

    self.entityFile = 'data/entity.lua'
    self.launchAngle = nil;

    -- an entity has a good chance of having a hitbox
    self.hitBox = nil
    -- singular attack
    self.attackHitBox = nil
    -- mutliple attacks ? todo fixme
    -- i don't know about this yet
    self.attackHitBoxes = nil
    self.health = BASE_HEALTH
    self.attackDamage = BASE_ATTACK
    self.active = true
end

function Entity:handleCollisions(collisions, dt)
    if #collisions == 0 then
        self.onGround = false
        return
    end
end

function Entity:clearAttacks()
    print('before self.attacks = '..tostring(self.attacks))
    self.attacks = {}
    print('after self.attacks = '..tostring(self.attacks))
    self.attackedObjects = {}
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

function Entity:setDamage(dmg)
end

function Entity:updateDamage(dt)
end

function Entity:updateDead(dt)
end

function Entity:reloadData()
    print(self.name)
    
end

function Entity:destroy()
    if self.img then
        self.img = nil
    end
end

return Entity
