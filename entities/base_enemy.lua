local Class = require'libs.hump.class'
local Entity = require'entity'
local HitBox = require'components.hitbox'

BaseEnemy = Class{
    __includes = Entity
}

local ENEMY_HEIGHT = 64
local ENEMY_WIDTH = 32

-- enemy states
local ENS_RUN = 0

local RIGHT = 1
local LEGFT = -1

local MAX_SPEED = 80

local BASE_FRICTION = 10

local BASE_HEALTH = 2
local BASE_DAMAGE = 1

function BaseEnemy:init(x,y)
    Entity:init(x,y,ENEMY_WIDTH, ENEMY_HEIGHT)
    print("top of BaseEnemy init")
    local img = love.graphics.newImage('assets/base_enemy_block.png')
    local w = ENEMY_WIDTH
    local h = ENEMY_HEIGHT
    self.name = "BaseEnemy"
    self.collType = "bounce"

    self.x = x
    self.y = y
    self.w = w
    self.h = h

    self.img = img

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

    print("enemy hitbox = "..tostring(self.hitBox))
    return self
end

function BaseEnemy:update(dt)
    if self.state == ENS_RUN then
        self:updateRunning(dt)
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

function BaseEnemy:draw()
    -- print("hitting baseEnemy:draw")
    lg.draw(self.img, math.floor(self.x), math.floor(self.y))
    self.hitBox:draw()
end
