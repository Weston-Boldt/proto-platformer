Player = {
    -- todo fixme calibrate
    corners = {-6, 5, -22, -0.5} 
}
PS_RUN, PS_CLIMB, PS_CARRY, PS_THROW, PS_DEAD = 0,1,2,3,4 -- Player states
local GD_UP, GD_HORIZONTAL, GD_DOWN = 0,2,4 -- Gun directions


local lg = love.graphics
Player.__index = Player

function Player.create(x,y,level)
    local self = setmetatable({}, Player)
    -- todo fixme
    self.img = love.graphics.newImage('assets/character_block.png')
    -- self.x, self.y = x, y
    self.x, self.y = 16, 16
    self.xspeed = 0
    self.yspeed = 0
    self.xacc = 100
    self.maxspeed = 600
    self.friction = 20 
    self.gravity = 80

    self.onGround = false
    self.time = 0
    -- todo int or str?
    -- i.e. left or right
    -- instead of -1 for left 1 for right
    self.lastDir = 1
    self.dir = 1

    self.state = PS_RUN
    self.gundir = GD_HORIZONTAL
    self.shooting = false
    self.bulletStreamLength = 0
    self.streamCollided = false
    self.bulletQuad = love.graphics.newQuad(
        0, 0, 10, 10, 16, 16
    )
end

function Player:update(dt)
end

function Player:draw()
    lg.draw(self.img, self.x, self.y)
end
