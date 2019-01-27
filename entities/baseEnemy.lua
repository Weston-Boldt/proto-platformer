local Class = require'libs.hump.class'
local Entity = require'entity'
local HitBox = require'components.hitbox'

BaseEnemy = Class{
    __includes = Entity
}

BASE_ENEMY_HEIGHT = 64
BASE_ENEMY_WIDTH = 32
BASE_ENEMY_HITBOX_HEIGHT = 64
BASE_ENEMY_HITBOX_WIDTH = 32

-- enemy states
ENS_RUN, ENS_DAMAGE, ENS_DEAD = 0, 1, 2

MAX_SPEED = 80

BASE_FRICTION = 10

DAMAGE_TIME_MAX = 0.5

function BaseEnemy:init(x,y)
    Entity:init(x,y,BASE_ENEMY_WIDTH, BASE_ENEMY_HEIGHT)

    self.img = love.graphics.newImage('assets/base_enemy_block.png')
    self.name = "BaseEnemy"
    self.collType = "bounce"

    self.x = x
    self.y = y

    self.dataFile = 'data/baseEnemy-data.lua'

    self.hitBox = HitBox(self,
        self.x, self.y,
        BASE_ENEMY_HITBOX_WIDTH,
        BASE_ENEMY_HITBOX_HEIGHT
    )

    self:reloadData()
    return self
end

function BaseEnemy:update(dt)
    if self.state == ENS_RUN then
        self:updateRunning(dt)
    elseif self.state == ENS_DAMAGE then
        self:updateDamage(dt)
    elseif self.state == ENS_DEAD then
        print('before = '..tostring(self.active))
        self.active = false
        print('after = '..tostring(self.active))

        self:updateDead(dt)
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
    if self.state == ENS_DAMAGE then
        return
    end

    self.health = self.health - attackDmg
    print('self.health = '..tostring(self.health))
    if self.health <= 0 then
        print('state should be dead')
        self.state = ENS_DEAD
    else
        self.foo = ''
        self.state = ENS_DAMAGE
    end

    self.damageTime = DAMAGE_TIME_MAX
end

function BaseEnemy:updateDamage(dt)
    if self.damageTime > 0 then
        self.damageTime = self.damageTime - dt
    else
        self.state = ENS_RUN
    end
end

function BaseEnemy:updateDead(dt)
    -- death animation
end

function BaseEnemy:draw()
    -- print("hitting baseEnemy:draw")
    lg.draw(self.img, math.floor(self.x), math.floor(self.y))
    self.hitBox:draw()
end
