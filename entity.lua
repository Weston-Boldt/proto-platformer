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

function Entity:init(x, y, w, h)
    -- self.world = world
    self.x = x
    self.y = y
    self.w = w
    self.h = h

    self.states = {
        base = StBase(self)
    }

    self.dataFile = 'data/entity-data.lua'
    self:reloadData()
    return self
end

function Entity:changeState(key)
    self.states[key]:enter()
end

function Entity:detachHitBox(hitBoxKey)
    if not self[hitBoxKey] then
        return 
    end
    self[hitBoxKey]:detach()
    self[hitBoxKey] = false
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

--[[
    will reload all the properties from the
    entities dataFile and load them onto the object
]]--
function Entity:reloadData()
    if not fileExists(self.dataFile) then
        print('no entity data, returning')
        return;
    end
    local newEntityData = loadfile(self.dataFile)('hello')
    for key, value in pairs(newEntityData) do
        self[key] = value
    end
end

function Entity:destroy()
    if self.img then
        self.img = nil
    end
end

return Entity
