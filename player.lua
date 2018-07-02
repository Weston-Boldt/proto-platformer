GRAVITY=350;
RUN_SPEED = 500
BRAKE_SPEED = 250
MAX_SPEED = 160
Player = {
    -- todo fixme calibrate
    corners = {-6, 5, -22, -0.5} 
}
LEFT = -1
RIGHT = 1
PS_RUN, PS_CLIMB, PS_CARRY, PS_THROW, PS_DEAD = 0,1,2,3,4 -- Player states
local GD_UP, GD_HORIZONTAL, GD_DOWN = 0,2,4 -- Gun directions


local lg = love.graphics
Player.__index = Player

function Player.create(x,y,level)
    local self = setmetatable({}, Player)
    -- todo fixme
    self.img = love.graphics.newImage('assets/character_block.png')
    -- self.x, self.y = x, y
    self.x = x
    self.y = y
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
    self.lastDir = RIGHT
    self.dir = RIGHT

    self.state = PS_RUN
    self.gundir = GD_HORIZONTAL
    self.shooting = false
    self.bulletStreamLength = 0
    self.streamCollided = false
    self.actionName = "";
    self.bulletQuad = love.graphics.newQuad(
        0, 0, 10, 10, 16, 16
    )
    return self
end

function Player:updateRunning(dt)
    local changedDir = false
    -- chcek if both direction keys are pressed
    local both = keystate.right and keystate.left

    -- caveat:
    --  evaling walkingRight and wwalkingLeft
    --  everytime may be costly
    local walkingRight = (not both and keystate.right) or
                         (both and self.lastDir == RIGHT)
    local walkingLeft = (not both and keystate.left) or
                        (both and self.lastDir == LEFT)
    -- walking right
    if walkingRight then
        self.xspeed = self.xspeed + RUN_SPEED*dt
        -- reset
        if self.dir == LEFT then
            self.dir = RIGHT
            changedDir = true
        end
    elseif walkingLeft then
        self.xspeed = self.xspeed - RUN_SPEED*dt
        if self.dir == RIGHT then
            self.dir = LEFT
            changedDir = true
        end 
    end

    if self.xspeed < 0 then
        self.xspeed = self.xspeed + math.max(dt*BRAKE_SPEED, self.xspeed)
    elseif self.xspeed > 0 then
        self.xspeed = self.xspeed - math.min(dt*BRAKE_SPEED, self.xspeed)
    end 
    self.x = self.x + self.xspeed*dt
    if collideX(self) == true then
    end
    -- Update gravity
    self.yspeed = self.yspeed + GRAVITY*dt
    -- Move in y axis
    -- check for collisions
    self.y = self.y + self.yspeed*dt
    if self.y >= 500 then
        self.y = 500
    end
end

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
    lg.draw(self.img, self.x, self.y)
    lg.print(self.actionName)
    lg.print("\nx="..self.x.."\t\t\txspeed="..self.xspeed)
    lg.print("\n\ny="..self.y.."\t\t\tyspeed="..self.yspeed)

    if keystate.right then
        lg.print("\n\n\npressing right")
    elseif keystate.left then
        lg.print("\n\n\npressing left")
    end

    lg.print("\n\n\n\nlastDir="..self.lastDir.."\tdir="..self.dir)
end

function Player:action(actionName)
    -- debugging 
    self.actionName = actionName

    if action == "left" or action == "right" then
        if action == "left" then
            self.lastDir = LEFT
        else
            self.lastDir = RIGHT
        end 
    end 
end
