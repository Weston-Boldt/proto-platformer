local Class = require'libs.hump.class'
local Entity = require'entity'
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
local GD_UP, GD_HORIZONTAL, GD_DOWN = 0,2,4 -- Gun directions

local NORMAL_GRAVITY=80
local BRAKE_SPEED = 350
local MAX_SPEED = 160
local MAX_JUMP = 100
local JUMP_TIME_MAX = 0.5

local lg = love.graphics
Player.__index = Player

function Player:init(x,y, level)

    local img = love.graphics.newImage('assets/character_block.png')
    local w = img:getWidth()
    local h = img:getHeight()

    Entity.init(self,x,y,w,h)
    self.img = img
    -- local self = setmetatable({}, Player)
    -- todo fixme
    --      actually idk what needs to be fixed here,
    --      maybe it was a comment on how i don't just want a green
    --      block as the player character ?
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
    self.gundir = GD_HORIZONTAL
    self.shooting = false
    self.bulletStreamLength = 0
    self.streamCollided = false
    self.actionName = "";
    self.bulletQuad = love.graphics.newQuad(
        0, 0, 10, 10, 16, 17
    )
    self.timesJumped = 0

    return self
end

function Player.create(x,y,level)
end

function Player:updateRunning(dt)
    local changedDir = false
    -- chcek if both direction keys are pressed
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
    -- end

    -- cap speed
    self.xspeed = cap(self.xspeed, -MAX_SPEED, MAX_SPEED);
    -- self.x = self.x + self.xspeed*dt
    goalX = self.x + self.xspeed
    -- if collideX(self) == true then
    -- end

    self.yspeed = self.yspeed * (1 - math.min(dt * self.friction, 1))
    -- Move in y axis
    -- check for collisions
    -- self.y = self.y + self.yspeed*dt
    -- if love.keyboard.isDown(config_keys.jump) then 
    if not self.onGround then
        print("not on the ground")
        if self.jumping then
            print("jumping so should be jumping")
            self:updateJumping(dt)
        end
        --[[
        lg.print("\n\n\n\n\n\n\nupdating jump");
        print("not on ground so adding gravity")
        if self.jumping then
            print("jumping so should be updating jump")
            self:updateJumping(dt)
        end
        self.yspeed = self.yspeed + self.gravity*dt
    else
        self.gravity = NORMAL_GRAVITY
        self.yspeed = 0
        --]]
    end
    
    self.yspeed = self.yspeed + self.gravity *dt
    -- self.xspeed = cap(self.xspeed, -MAX_SPEED, MAX_SPEED)

    
    goalY = self.y + self.yspeed
    self.x, self.y, collisions = map.world:move(self, goalX, goalY)

    for i, coll in ipairs(collisions) do
        if coll.touch.y > goalY then
            print("first if check");
            player.hasReachedMax = true
            self.onGround = false
        -- elseif coll.touch.y < goalY and self.jumping then
        --     print("second if check");
        --     self.jumping = false
        --     player.hasReachedMax = true
        --     self.onGround = false
        elseif coll.normal.y < 0 then
            self.jumping = false
            player.hasReachedMax = false
            self.onGround = true
            self.yspeed = 0
            self.jump_time = JUMP_TIME_MAX
        end
    end
    --[[
    if self.y >= 500 then
        self.y = 500
        self.yspeed = 0
        self.timesJumped = 0
        self.onGround = true
    end
    -- ]]
end

function Player:updateJumping(dt)
    print("top of Player:updateJumping")
    if self.jump_time > 0
    and love.keyboard.isDown(config_keys.jump) then
        self.jump_time = self.jump_time - dt
        self.yspeed = self.yspeed - self.jumpAcc * (dt / JUMP_TIME_MAX)
        local targetJumpSpeed = self.jumpAcc*dt;
        print("jump speed is gonna  = "..targetJumpSpeed.."\n")
        self.yspeed = self.yspeed - targetJumpSpeed
    end
    --[[
    if -self.yspeed < MAX_JUMP and not self.hasReachedMax then
        self.gravity = 0;
        print("self yspeed is less than < MAX_JUMP")
        local targetJumpSpeed = self.jumpAcc*dt;
        print("jump speed is gonna  = "..targetJumpSpeed.."\n")
        self.yspeed = self.yspeed - targetJumpSpeed
    elseif math.abs(self.yspeed) > MAX_JUMP then
        self.gravity = NORMAL_GRAVITY
        print("has reached max\n");
        self.hasReachedMax = true
    end
    --]]
    --[[
    print("before self.yspeed = "..self.yspeed.." max_jump="..MAX_JUMP)
    if -self.yspeed < MAX_JUMP and not self.hasReachedMax then
        print('not hit max_jump');
        self.yspeed = self.yspeed - self.jumpAcc* dt
        -- self.gravity = self.gravity * .5
        self.gravity = 50;
        print("after yspeed = "..self.yspeed)
    end
    if math.abs(self.yspeed) > MAX_JUMP then
        print('hit max_jump');
        self.gravity = 100
        self.hasReachedMax = true
    end
    print("after self.yspeed = "..self.yspeed.." max_jump="..MAX_JUMP)
    --]]
end

function Player:jump()
    self.jumping = true
    self.onGround = false
    self.yspeed = self.yspeed - self.jumpAcc
    --    if self.onGround == true --[[ and self.state ~= PS_DEAD --]] or
    --    self.onGround == false and self.timesJumped < 2 then
    --        self.timesJumped = self.timesJumped + 1
    --        self.onGround = false
    --        self.yspeed = -JUMP_POWER
    --    end 
    -- self.onGround = false
end

--[[
function player:collisionFilter(other)
    local x, y, w, h = self.world:getRect(other)
    local playerBottom = self.y + self.h
    local otherBottom = y + h

    if playerBottom <= y then -- bottom of player collides with top of platform.
        return 'slide'
    end
end
--]]

function Player:update(dt)
    -- reset shooting
    self.shooting = false
    -- first update states
    if self.state == PS_RUN then
        self:updateRunning(dt)
    end
    -- Cap speeds
    --[[
    if self.xspeed < 0 then
        self.xspeed = self.xspeed + math.max(dt*BRAKE_SPEED, self.xspeed)
    elseif self.xspeed > 0 then
        self.xspeed = self.xspeed - math.min(dt*BRAKE_SPEED, self.xspeed)
    end
    --]]

    -- check for collisions
    --[[
    if collideX(self) == true then
        self.xspeed = -1.0*self.xspeed
    end
    --]]
    --[[
    if collideY(self) == true then
        self.yspeed = 0
    end
    --]]
end

function Player:draw()
    -- lg.draw(self.img, self.x, self.y,0,1,1,self.img:getWidth(),self.img:getHeight())
    lg.draw(self.img, math.floor(self.x), math.floor(self.y))
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
end

function Player:action(actionName)
    -- debugging 
    self.actionName = actionName

    if actionName == "jump" and not self.jumping then
        print("initiating jump")
        self:jump()
    elseif actionName == "left" or actionName == "right" then
        if actionName == "left" then
            self.lastDir = LEFT
        else
            self.lastDir = RIGHT
        end 
    end 
end
