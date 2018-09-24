local Class = require'libs.hump.class'
local Entity = require'entity'
local HitBox = require'components.hitbox'

BaseEnemy = Class{
    __includes = Entity
}

local ENEMY_HEIGHT = 64
local ENEMY_WIDTH = 32
local HITBOX_HEIGHT = 64
local HITBOX_WIDTH = 32

-- enemy states
local ENS_RUN, ENS_DAMAGE, ENS_DEAD = 0, 1, 2

local MAX_SPEED = 80

local BASE_FRICTION = 10

local DAMAGE_TIME_MAX = 0.5

function BaseEnemy:init(x,y)
    Entity:init(x,y,ENEMY_WIDTH, ENEMY_HEIGHT)
    print("top of BaseEnemy init")
    self.img = love.graphics.newImage('assets/base_enemy_block.png')
    self.name = "BaseEnemy"
    self.collType = "bounce"

    self.x = x
    self.y = y
    self.w = ENEMY_WIDTH
    self.h = ENEMY_HEIGHT

    self.hitBox = HitBox(self, self.x, self.y, HITBOX_WIDTH, HITBOX_HEIGHT)
    self.xspeed = 0;
    self.yspeed = 0;

    self.xacc = 25
    self.moving = true
    self.onGround = false
    self.lastDir = RIGHT
    self.dir = RIGHT
    self.friction = 10
    self.gravity = NORMAL_GRAVITY
    self.state = ENS_RUN
    self.health = BASE_HEALTH

    self.damageTime = DAMAGE_TIME_MAX

    print('health= '..tostring(self.health))

    print("enemy hitbox = "..tostring(self.hitBox))
    return self
end

function BaseEnemy:update(dt)
    if self.state == ENS_RUN then
        self:updateRunning(dt)
    elseif self.state == ENS_DAMAGE then
        print('should be damaged')
        self:updateDamage(dt)
    elseif self.state == ENS_DEAD then
        print('should be dead')
        self:updateDamage(dt)
    end

    -- print("hitting baseEnemy:update")
    self.hitBox:update(self.x,self.y,dt)
end

function BaseEnemy:updateRunning(dt)
    applyFriction(self,dt)

    if self.moving then
        self.xspeed = self.xspeed + ((self.xacc*dt) * self.dir) 
    end

    self.xspeed = cap(self.xspeed, -MAX_SPEED, MAX_SPEED)
    self.yspeed = self.yspeed + self.gravity * dt

    self.x = self.x + self.xspeed
    self.y = self.y + self.yspeed
end

function BaseEnemy:handleCollisions(collisions,dt)
    Entity:handleCollisions(self)

    for i, coll in pairs(collisions) do
        if coll.normal.x ~= 0 then
            self.dir = self.dir * -1
        end
        if coll.normal.y < 0 then
            self.onGround = true
            self.yspeed = 0
        end
    end
end

function BaseEnemy:setDamage(attackDmg)
    self.health = self.health - attackDmg
    if self.health < 0 then
        print('state should be dead')
        self.state = ENS_DEAD
    else
        self.state = ENS_DAMAGE
    end
    self.damageTime = DAMAGE_TIME_MAX
end

function BaseEnemy:updateDamage(dt)
    print('top of baseenemy:updatedamage')
    if self.damageTime > 0 then
        print('before  time = '..tostring(self.damageTime))
        self.damageTime = self.damageTime - dt
        print('after time = '..tostring(self.damageTime))
    else
        self.state = ENS_RUN
    end
end

function BaseEnemy:draw()
    -- print("hitting baseEnemy:draw")
    lg.draw(self.img, math.floor(self.x), math.floor(self.y))
    self.hitBox:draw()
end
