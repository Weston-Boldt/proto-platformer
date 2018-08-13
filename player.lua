local Class = require'libs.hump.class'
local Entity = require'entity'
local HitBox = require'components.hitbox'

Player = Class{
    --[[
    corners = {
        -6, 5, -22, -0.5,
    }; -- why does this need a semi colon
    --]]
    __includes = Entity
    -- todo fixme calibrate
}

-- local PLAYER_WIDTH, PLAYER_HEIGHT = 16, 22 LEFT = -1
LEFT = -1
RIGHT = 1
PS_RUN, PS_CLIMB, PS_CARRY, PS_THROW, PS_DEAD = 0,1,2,3,4 -- Player states

PLAYER_WIDTH = 32
PLAYER_HEIGHT = 64
-- give the player a bit of edge room when being attacked
-- but still want to collide normally with the map
HITBOX_WIDTH = PLAYER_WIDTH * .75 
HITBOX_HEIGHT = PLAYER_HEIGHT

local GD_UP, GD_HORIZONTAL, GD_DOWN = 0,2,4 -- Gun directions

local NORMAL_GRAVITY=80
local BRAKE_SPEED = 350
local MAX_SPEED = 160
local MAX_JUMP = 100
local JUMP_TIME_MAX = 0.5

local lg = love.graphics
Player.__index = Player

function Player:init(x,y,level)

    local img = love.graphics.newImage('assets/character_block.png')
    local w = img:getWidth()
    local h = img:getHeight()

    Entity.init(self,x,y,w,h)
    self.img = img
    self.x = x
    self.y = y
    self.xspeed = 0
    self.yspeed = 0
    self.xacc = 50
    self.friction = 10
    self.gravity = NORMAL_GRAVITY
    self.hasReachedMax = false
    self.jump_time = JUMP_TIME_MAX

    self.onGround = false
    self.time = 0
    self.lastDir = RIGHT
    self.dir = RIGHT
    self.jumpAcc = 25

    self.jumping = false;
    self.state = PS_RUN
    self.actionName = "";
    self.hitBox = HitBox;
    self.hitBox:init(
        self,
        self.x,
        self.y,
        HITBOX_HEIGHT,  
        HITBOX_WIDTH
    )
    --[[
    self.gundir = GD_HORIZONTAL
    self.shooting = false
    self.bulletStreamLength = 0
    self.streamCollided = false
    self.bulletQuad = love.graphics.newQuad(
        0, 0, 10, 10, 16, 17
    )
    self.timesJumped = 0
    --]]
    return self
end

function Player:updateRunning(dt)
    local changedDir = false
    local both = keystate.right and keystate.left

    local walkingRight = (not both and keystate.right) or
                         (both and self.lastDir == RIGHT)
    local walkingLeft = (not both and keystate.left) or
                        (both and self.lastDir == LEFT)
    self.xspeed = self.xspeed * (1 - math.min(dt * self.friction, 1))
    if walkingRight and self.xspeed > -MAX_SPEED then
        self.xspeed = self.xspeed + self.xacc*dt
        if self.dir == LEFT then
            self.dir = RIGHT
            changedDir = true
        end
    elseif walkingLeft and self.xspeed < MAX_SPEED then
        self.xspeed = self.xspeed - self.xacc*dt
        if self.dir == RIGHT then
            self.dir = LEFT
            changedDir = true
        end 
    end

    self.xspeed = cap(self.xspeed, -MAX_SPEED, MAX_SPEED);
    goalX = self.x + self.xspeed

    self.yspeed = self.yspeed * (1 - math.min(dt * self.friction, 1))
    if not self.onGround then
        --print("not on the ground")
        if self.jumping then
           -- print("jumping so should be jumping")
            self:updateJumping(dt)
        end
    end
    
    self.yspeed = self.yspeed + self.gravity *dt

    goalY = self.y + self.yspeed
    self.x, self.y, collisions = map.world:move(self, goalX, goalY)

    for i, coll in ipairs(collisions) do
        if coll.touch.y > goalY then
            -- print("first if check");
            player.hasReachedMax = true
            self.onGround = false
        elseif coll.normal.y < 0 then
            self.jumping = false
            player.hasReachedMax = false
            self.onGround = true
            self.yspeed = 0
            self.jump_time = JUMP_TIME_MAX
        end
    end
end

function Player:updateJumping(dt)
    -- print("top of Player:updateJumping")
    if self.jump_time > 0
    and love.keyboard.isDown(config_keys.jump) then
        self.jump_time = self.jump_time - dt
        self.yspeed = self.yspeed - self.jumpAcc * (dt / JUMP_TIME_MAX)
        local targetJumpSpeed = self.jumpAcc*dt;
        -- print("jump speed is gonna  = "..targetJumpSpeed.."\n")
        self.yspeed = self.yspeed - targetJumpSpeed
    end
end

function Player:jump()
    self.jumping = true
    self.onGround = false
    self.yspeed = self.yspeed - self.jumpAcc
end

function Player:update(dt)
    -- reset shooting
    -- self.shooting = false
    -- first update states
    if self.state == PS_RUN then
        self:updateRunning(dt)
    end

    self.hitBox:update(dt)
end

function Player:draw()
    lg.draw(self.img, math.floor(self.x), math.floor(self.y))
    --[[
    lg.print(self.actionName)
    lg.print("\nx="..self.x.."\t\t\txspeed="..self.xspeed)
    lg.print("\n\ny="..self.y.."\t\t\tyspeed="..self.yspeed)

    if keystate.right then
        lg.print("\n\n\npressing right")
    elseif keystate.left then
        lg.print("\n\n\npressing left")
    end
    if self.jumping then
        lg.print("\n\n\njumping")
    else 
        lg.print("\n\n\nnot jumping")
    end

    -- lg.print("\n\n\n\nlastDir="..self.lastDir.."\tdir="..self.dir)
    lg.print("\n\n\n\nself.onGround="..tostring(self.onGround))
    lg.print("\n\n\n\n\nself.actionName="..self.actionName)
    lg.print("\n\n\n\n\n\njumping="..tostring(self.jumping).."\n")
    lg.print("\n\n\n\n\n\n\ngravity="..tostring(self.gravity).."\n\n")
    --]]
end

function Player:action(actionName)
    -- debugging 
    self.actionName = actionName

    if actionName == "jump" and not self.jumping then
        --print("initiating jump")
        self:jump()
    elseif actionName == "left" or actionName == "right" then
        if actionName == "left" then
            self.lastDir = LEFT
        else
            self.lastDir = RIGHT
        end 
    end 
end
