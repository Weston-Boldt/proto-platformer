local Class = require'libs.hump.class'
local Entity = require'entity'
local HitBox = require'components.hitbox'

BaseEnemy = Class{
    __includes = Entity
}

local ENEMY_HEIGHT = 64
local ENEMY_WIDTH = 32
function BaseEnemy:init(x,y)
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
    print("enemy hitbox = "..tostring(self.hitBox))
    return self
end

function BaseEnemy:update(dt)
    -- print("hitting baseEnemy:update")
end

function BaseEnemy:draw()
    -- print("hitting baseEnemy:draw")
    lg.draw(self.img, math.floor(self.x), math.floor(self.y))
end
