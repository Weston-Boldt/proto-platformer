local Class = require'libs.hump.class'
local Entity = require'entity'
local HitBox = require'components.hitbox'
local Sensor = require'components.sensor'

BaseEnemy = Class{
    __includes = Entity
}

local ENEMY_HEIGHT = 64
local ENEMY_WIDTH = 32
local SENSOR_SIZE = 32
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

    self.sensors = nil;
    self.hitBox = HitBox(self, self.x, self.y, HITBOX_HEIGHT, HITBOX_WIDTH)
    self.leftSensor = Sensor(
        self.x - ENEMY_WIDTH, self.y + ENEMY_HEIGHT
    )
    self.rightSensor = Sensor(
        self.x + ENEMY_WIDTH, self.y + ENEMY_HEIGHT
    )

    print("enemy hitbox = "..tostring(self.hitBox))
    self.collisions = {}
    return self
end

function BaseEnemy:update(dt)
    -- print("hitting baseEnemy:update")
    self.leftSensor:update(
        self.x - ENEMY_WIDTH, self.y + ENEMY_HEIGHT, dt
    )
    self.rightSensor:update(
        self.x + ENEMY_WIDTH, self.y + ENEMY_HEIGHT, dt
    )
end

function BaseEnemy:handleCollisions(collisions,dt)
    for i, coll in pairs(collisions) do
        print("coll = "..coll)
    end
end

function BaseEnemy:draw()
    -- print("hitting baseEnemy:draw")
    lg.draw(self.img, math.floor(self.x), math.floor(self.y))
    self.leftSensor:draw()
    self.rightSensor:draw()
end
