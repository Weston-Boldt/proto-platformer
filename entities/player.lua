local Class = require'libs.hump.class'
local Entity = require'entity'
local Timer = require'libs.hump.timer'
local HitBox = require'components.hitbox'
local Anim8 = require'libs.anim8.anim8'

local lg = love.graphics

local run = 'run'
local launch = 'launch'
local attack = 'attack'

-- local PLAYER_WIDTH, PLAYER_HEIGHT = 16, 22 LEFT = -1
PS_RUN, PS_SHOOTING, PS_LAUNCH,
PS_THROW, PS_DEAD, PS_DMG = 0,1,2,3,4,5,6 -- Player states 
PLAYER_WIDTH = SZ_TILE
PLAYER_HEIGHT = SZ_DBL_TILE
-- give the player a bit of edge room when being attacked
-- but still want to collide normally with the map
local HITBOX_WIDTH = PLAYER_WIDTH
local HITBOX_HEIGHT = PLAYER_HEIGHT

P_MAX_SPEED = 160

P_JUMP_TIME_MAX = 0.5

P_ATTACK_TIME_MAX = 0.5

local DAMAGE_TIME_MAX = 0.5

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

    self = Entity.init(self,dataFile, x,y,PLAYER_WIDTH,PLAYER_HEIGHT)

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

    states = {
        run = StPlayerRunning(self),
        attack = StPlayerAttacking(self),
        launch = StLaunching(self)
    };

    self:reloadData()
    return self
end

function Player:updateRunning(dt)
    applyFriction(self, dt)
    --[[
    this stuff could be moved to another function and
    be called in the update function but ONLY if the object is moving
    --]]
    local both = keystate.right and keystate.left

    local walkingRight = (not both and keystate.right) or
                         (both and self.lastDir == RIGHT)
    local walkingLeft = (not both and keystate.left) or
                        (both and self.lastDir == LEFT)

    if walkingRight and self.xspeed > -P_MAX_SPEED then
        self.xspeed = self.xspeed + self.xacc*dt
        if self.dir == LEFT then
            self.dir = RIGHT
        end
    elseif walkingLeft and self.xspeed < P_MAX_SPEED then
        self.xspeed = self.xspeed - self.xacc*dt
        if self.dir == RIGHT then
            self.dir = LEFT
        end 
    elseif self.jumping and (not walkingRight and not walkingLeft) then
        if self.dir == LEFT then
            self.xspeed = self.xspeed - self.xspeed*dt
        elseif self.dir == RIGHT then
            self.xspeed = self.xspeed + self.xspeed*dt
        end
    end

    self.xspeed = cap(self.xspeed, -P_MAX_SPEED, P_MAX_SPEED);
    if math.floor(self.xspeed) == 0 and not (walkingLeft or walkingRight) then
        self.xspeed = 0
    end
    self.x = self.x + self.xspeed

    if not self.onGround then
        --print("not on the ground")
        if self.jumping then
           -- print("jumping so should be jumping")
            self:updateJumping(dt)
        end
    end
    
    applyGravity(self,dt)
    self.y = self.y + self.yspeed

    -- self.x, self.y, collisions = map.world:move(self, self.x, self.y)
end

function Player:launch(dt)
    self.state = PS_LAUNCH
    -- TODO FIXME this may need to go away
    -- need to test the behavior of both
    -- self:updateLaunch(dt)
    self.canAttack = false
    -- self.needToLaunch = false

    self.launchHitBox = HitBox(self,
        self.x, self.y,
        -- these will need to shift likely
        SZ_DBL_TILE, SZ_DBL_TILE,
        true, true
    )

    -- if they hit a wall on their left, they should be 
    -- facing the right direciton after the launch so set that now
    -- as it's probably the most appropriate time
    if not inTable(self.attackDir, {AD_UP, AD_DOWN}) then
        self.dir = self.dir * -1
    end

    Timer.after(2, function()
        -- player can break out of launch by
        -- punching again
        if self.state == PS_LAUNCH then
            self.state = PS_RUN
        end
        self.needToLaunch = false
        self.canAttack = true

        self:detachHitBox('launchHitBox')
    end)
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

function Player:updateShooting(dt)
    if self.attackTime > (P_ATTACK_TIME_MAX - (P_ATTACK_TIME_MAX / 16)) then
        if (keystate.left and self.dir ~= LEFT)
        or (keystate.right and self.dir ~= RIGHT) then
            self.lastDir = self.dir
            self.dir = self.dir * -1
        end

        self.attackDir = self:getAttackDir()
        self.attackHitBox.x, self.attackHitBox.y,
        self.attackHitBox.w, self.attackHitBox.h = self:getAttackHitBoxRect()

        --[[
        local attackDir = self:getAttackDir()
        if self.attackDir ~= attackDir then
            self.attackDir = attackDir
        end

            self.attackHitBox.attack = false
            self.attackHitBox.x = self:getAttackHitBoxX()
        end
        --]]
        self.launchAngle = self:getLaunchAngle()
    else
        self.attackHitBox.attack = true
    end

    if self.attackTime > 0 then
        self.attackTime = self.attackTime - dt
    else
        -- print("about to detatch")
        -- detatch the hitbox off the object
        -- to get swept up and removed by the 
        -- print("before "..tostring(self.attackHitBox.obj))
        self:detachHitBox('attackHitBox')

        self.attackTime = P_ATTACK_TIME_MAX
        if self.needToLaunch then
            self:launch(dt)
        else
            self.state = PS_RUN
        end
    end
    -- -- applyFriction(self, dt)
    -- -- applyGravity(self,dt)
    -- if not self.onGround then
    --     --print("not on the ground")
    --     if self.jumping then
    --        -- print("jumping so should be jumping")
    --         self:updateJumping(dt)
    --     end
    -- end
    -- self.x = self.x + self.xspeed 
    -- self.y = self.y + self.yspeed 
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

function Player:updateLaunch(dt)
    local speed = 500
    self.x = self.x + math.sin(self.launchAngle) * dt * speed
    self.y = self.y + math.cos(self.launchAngle) * dt * speed
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
    if self.state == PS_RUN then
        self:updateRunning(dt)
    elseif self.state == PS_SHOOTING then
        self:updateShooting(dt)
    elseif self.state == PS_LAUNCH then
        self:updateLaunch(dt)
    end

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

-- kind of a weak warp function
function Player:warp(x,y)
    self.x = x
    self.y = y
    self.xspeed = 0
    self.yspeed = 0
end

function Player:doAction()
    self.doingAction = true
end

function Player:getAttackHitBoxY()
    if self.attackDir == AD_UP then
        return self.y - (self.h / 2)
    elseif self.attackDir == AD_UP_DIAG then
        return self.y - (self.h / 2)
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
        return PLAYER_WIDTH, (PLAYER_HEIGHT / 2) + 5 
    -- shorten just the width if it's just up && down
    elseif self.attackDir == AD_UP
    or self.attackDir == AD_DOWN then
        return PLAYER_WIDTH, PLAYER_HEIGHT
    end

    -- normal attack width if it's a horizontal attack
    return PLAYER_WIDTH * 2, PLAYER_HEIGHT
end

function Player:shoot()
    if self.state == PS_SHOOTING
    or not self.canAttack 
    or self.state == PS_LAUNCH then
        return
    end
    self.xspeed = 0
    self.yspeed = 0

    self.canAttack = false
    Timer.after(0.8, function()
        self.canAttack=true
    end)

    if not self.jumpTime == self.jump_time_max then
        self.letGoOfJump = true
        self.jumpTime = 0
    end

    self.state = PS_SHOOTING;

    self.attackDir = self:getAttackDir()

    local hbX = self:getAttackHitBoxX()
    local hbY = self:getAttackHitBoxY()
    local hbW, hbH = self:getAttackHitBoxWH()

    self.attackHitBox = HitBox(self,
        hitBoxX, hitBoxY,
        hbW, hbH
    )
end

function Player:action(actionName)
    if actionName == "jump" and not self.jumping then
        self:jump()
    elseif actionName == "shoot" then
        self:shoot()
    elseif actionName == "action" then
        self:doAction()
    end
end
