require('../util')

local className

if empty(arg[1]) then
    print("please specify className")
    return
end

local className = arg[1]
local upper = string.upper(className)

local code = [[
local Class = require'libs.hump.class'
local Entity = require'entity'
local HitBox = require'components.hitbox'

local ]]..upper..[[_RUN, ]]..upper..[[_DAMAGE, ]]..upper..[[_DEAD = 1,2,3

local ]]..upper..[[_HEIGHT = 64
local ]]..upper..[[_WIDTH = 32
local HITBOX_HEIGHT = 64
local HITBOX_WIDTH = 32

local MAX_SPEED = 80
local BASE_FRICTION = 10

]]..className..[[ = Class{
    __includes = Entity
}

function ]]..className..[[:init(x,y)
    Entity:init(x,y, ]]..upper..[[_WIDTH, ]]..upper..[[_HEIGHT)
    self.img = love.graphics.newImage('assets/base_enemy_block.png')
    self.name = "]]..className..[["
    self.collType = "bounce"

    self.x = x
    self.y = y
    self.w = ]]..upper..[[_WIDTH
    self.h = ]]..upper..[[_HEIGHT

    self.hitBox = HitBox(self, self.x, self.y, HITBOX_WIDTH, HITBOX_HEIGHT)

    self.xspeed = 0;
    self.yspeed = 0;

    self.xacc = 25
    self.moving = false
    self.onGround = false
    self.lastDir = RIGHT
    self.dir = RIGHT
    self.friction = 10
    self.gravity = NORMAL_GRAVITY
    self.state = ]]..upper..[[_RUN
    self.health = BASE_HEALTH

    return self
end

function ]]..className..[[:update(dt)
    if self.state == ]]..upper..[[_RUN then
        self:updateRunning(dt)
    end
end

function ]]..className..[[:updateRunning(dt)
    applyFriction(self,dt)

    if self.moving then
        self.xspeed = self.xspeed + ((self.xacc*dt) * self.dir) 
    end

    self.xspeed = cap(self.xspeed, -MAX_SPEED, MAX_SPEED)
    self.yspeed = self.yspeed + self.gravity * dt

    self.x = self.x + self.xspeed
    self.y = self.y + self.yspeed
end

function ]]..className..[[:handleCollsions(collisions,dt)
    Entity:handleCollisions(self)
    for i, coll in pairs(collisions) do
        if coll.normal.y < 0 then
            self.onGround = true
            self.yspeed = 0
        end
    end
end

function ]]..className..[[:draw()
    lg.draw(self.img, math.floor(self.x), math.floor(self.y))
    self.hitBox:draw()
end
]]

local file,err = io.open("entities/"..className..".lua", "w")
if (err) then
print(err)
end
file:write(code)
file:close()

return 0
