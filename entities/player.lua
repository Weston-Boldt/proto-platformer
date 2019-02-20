local Class = require'libs.hump.class'
local Entity = require'entity'
local Timer = require'libs.hump.timer'
local HitBox = require'components.hitbox'
local Anim8 = require'libs.anim8.anim8'

local lg = love.graphics

local RUN = 'run'
local LAUNCH = 'launch'
local ATTACK = 'attack'

-- local PLAYER_WIDTH, PLAYER_HEIGHT = 16, 22 LEFT = -1
PLAYER_WIDTH = SZ_TILE
PLAYER_HEIGHT = SZ_DBL_TILE
-- give the player a bit of edge room when being attacked
-- but still want to collide normally with the map
local HITBOX_WIDTH = PLAYER_WIDTH
local HITBOX_HEIGHT = PLAYER_HEIGHT

P_MAX_SPEED = 160

P_JUMP_TIME_MAX = 0.5

P_ATTACK_TIME_MAX = 0.5

DAMAGE_TIME_MAX = 0.5

Player = Class{
    --[[
    corners = {
        -6, 5, -22, -0.5,
    };
    --]]
    __includes = Entity
}

Player.__index = Player

function Player:init(x,y,level)
    self = Entity.init(self,x,y,PLAYER_WIDTH,PLAYER_HEIGHT)

    self.dataFile = 'data/player-data.lua'

    self.img = love.graphics.newImage('assets/blue_tough_guy.png')

    -- AHHHHHH! this is a magic quad that works with the aseprite drawing i did 
    self.boundingQuad = lg.newQuad(12, 0, 53, SZ_DBL_TILE, self.img:getDimensions())

    self.name = "Player"
    self.x = x
    self.y = y

    self.hitBox = HitBox(
        self,
        self.x, self.y,
        --[[
        (self.x + self.w) / 2,
        self.y + (self.h / 2 ),
        --]]
        HITBOX_WIDTH,
        HITBOX_HEIGHT
    )
    self.states = {
        run = StPlayerRunning(self),
        attack = StPlayerAttacking(self),
        launch = StLaunching(self)
    };

    self:changeState(RUN)
    self:reloadData()

    return self
end


function Player:getLaunchAngle()
    if self.attackDir == AD_UP then
        return toRadian(270)
    elseif self.attackDir == AD_DOWN then
        return toRadian(90)
    end

    local baseAngle

    if self.dir == RIGHT then
        baseAngle = 180
    elseif self.dir == LEFT then
        baseAngle = 0
    end

    if self.attackDir == AD_HORIZONTAL then
        return toRadian(baseAngle)
    elseif self.attackDir == AD_UP_DIAG then
        return toRadian((baseAngle + (45 * self.dir)) % 360)
    elseif self.attackDir == AD_DOWN_DIAG then
        return toRadian((baseAngle + (45 * -self.dir)) % 360)
    end
end

function Player:getCollisionFilter(other)
    if not other.name then
        return 'slide'
    end
    local collTypes = {
        EnemyCollision = 'cross'
    }

    local collType = collTypes[other.name]
    if collType then
        return collType
    else
        return 'slide'
    end
end

function Player:handleCollisions(collisions, dt)
    Entity:handleCollisions(self)
    -- we are likely in the air?
    if #collisions == 0 then
        self.onGround = false
        return
    end
    for i, coll in pairs(collisions) do
        -- skip these for now without checking what they are
        -- as we are choosing to go through em anyways
        if coll.type == "cross" then
        else 
            if coll.normal.x ~= 0 then
                self.xspeed = 0
            end
            if coll.touch.y > self.y then
                self.onGround = false
                -- self.jump_time = JUMP_TIME_MAX
            elseif coll.normal.y < 0 then
                self.jumping = false
                self.onGround = true
                self.yspeed = 0
                self.jumpTime = self.jump_time_max
            end
        end
        -- todo fixme coll type will be depending
        -- on what coll type the object has
    end
end 

function Player:updateJumping(dt)
    -- print("top of Player:updateJumping")
    if self.jumpTime > 0
    and love.keyboard.isDown(config_keys.jump)
    and not self.letGoOfJump then
        self.jumpTime = self.jumpTime - dt
        self.yspeed = self.yspeed - self.jumpAcc * (dt / self.jump_time_max)
        local targetJumpSpeed = self.jumpAcc*dt;
        -- print("jump speed is gonna  = "..targetJumpSpeed.."\n")
        self.yspeed = self.yspeed - math.sqrt(targetJumpSpeed)
    else
        self.letGoOfJump = true
    end
end

function Player:jump()
    if self.onGround then
        self.jumping = true
        self.onGround = false
        self.letGoOfJump = false
        self.yspeed = self.yspeed - self.jumpAcc
    end
end

function Player:getAttackHitBoxRect()
    return self:getAttackHitBoxX(),
        self:getAttackHitBoxY(),
        self:getAttackHitBoxWH()
end

function Player:update(dt)
    --print("before doing action = "..tostring(self.doingAction))
    self.doingAction = false
    --print("after doing action = "..tostring(self.doingAction))
    --[[
    if not love.keyboard.isDown(config_keys.action) then
        self.doingAction = false
    end
    --]]
    -- reset shooting
    -- self.shooting = false
    -- first update states

    if not self.state then
        self:changeState(RUN)
    end

    self.states[self.state]:update(dt)

    self.hitBox:update(
        self.x, self.y,
        dt
    )

    if self.attackHitBox then
        self.attackHitBox:update(
            self:getAttackHitBoxRect()
        )
    end

    if self.launchHitBox then
        self.launchHitBox:update(
            self.x, self.y,
            SZ_DBL_TILE, SZ_DBL_TILE
        )
    end

    -- print("update player hitBox with x "..tostring(self.x))
end

function Player:draw()

    --[[
    self.hitBox:draw(
        math.floor(self.hitBox.x),math.floor(self.hitBox.y)
    )
    --]]
    lg.draw(self.img, self.boundingQuad, math.floor(self.x), math.floor(self.y), 0, 1, 1, 4)
    if self.attackHitBox then
        self.attackHitBox:draw(
            math.floor(self.attackHitBox.x),math.floor(self.attackHitBox.y)
        )
    end
    if self.launchHitBox then
        self.launchHitBox:draw(
            math.floor(self.launchHitBox.x),math.floor(self.launchHitBox.y)
        )
    end
end

function Player:doAction()
    self.doingAction = true
end

function Player:getAttackHitBoxY()
    if self.attackDir == AD_UP then
        return self.y - (self.h / 2)
    elseif self.attackDir == AD_UP_DIAG
    or self.attackDir == AD_DOWN_DIAG then
        return self.y
    elseif self.attackDir == AD_DOWN then
        return self.y + self.h 
    elseif self.attackDir == AD_DOWN_DIAG then
        return self.y + (self.h /2)
    -- TODO should there be a self.attackDir == AD_HORIZONTAL check?
    else
        return self.y
    end
end

-- don't have to change x pos if it's a diag attack because it
-- the left corner will be the same
function Player:getAttackHitBoxX()
    -- up and down? return x 
    if self.attackDir == AD_UP or self.attackDir == AD_DOWN then
        return self.x
    end

    if self.dir == LEFT then
        if self.attackDir == AD_UP_DIAG or self.attackDir == AD_DOWN_DIAG then
            return self.x - self.w
        end

        return self.x - (self.w * 2)
    elseif self.dir == RIGHT then
        return self.x + self.w
    end

    -- dir isn't set? just return self.x instead of nil
    -- to keep game running but this shouldn't happen ever
    return self.x
end

function Player:getAttackDir()
    local leftOrRight = (keystate.left or keystate.right)
    if keystate.up and not leftOrRight then
        return AD_UP
    elseif keystate.up and leftOrRight then
        return AD_UP_DIAG
    elseif keystate.down and leftOrRight then
        return AD_DOWN_DIAG
    elseif keystate.down and not leftOrRight then
        return AD_DOWN
    else
        return AD_HORIZONTAL
    end
end

function Player:getAttackHitBoxWH()
    -- shorten the width && height if they
    -- are punchgin up diag or down diag
    if self.attackDir == AD_UP_DIAG
    or self.attackDir == AD_DOWN_DIAG then
        -- give height a little bit more that way it'll
        -- cause launching when hitting a diag
        return PLAYER_WIDTH, PLAYER_HEIGHT
    -- shorten just the width if it's just up && down
    elseif self.attackDir == AD_UP
    or self.attackDir == AD_DOWN
    or self.attackDir == AD_UP_DIAG
    or self.attackDir == AD_DOWN_DIAG then
        return PLAYER_WIDTH, PLAYER_HEIGHT
    end

    -- normal attack width if it's a horizontal attack
    return PLAYER_WIDTH * 2, PLAYER_HEIGHT / 2
end

function Player:action(actionName)
    if actionName == "jump" and not self.jumping then
        self:jump()
    elseif actionName == "shoot" then
        print('should be here')
        self:changeState(ATTACK)
    elseif actionName == "action" then
        self:doAction()
    end
end
