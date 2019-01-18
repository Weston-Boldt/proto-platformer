local Class = require'libs.hump.class'

StPlayerRunning = Class {
    __includes = StRunning
}

function StPlayerRunning:init(obj)
    self = StRunning.init(self, obj)
    self.name = 'PlayerRunning'
    return self
end

function StPlayerRunning:updateRunning(dt)
    applyFriction(self.obj, dt)
    local both = keystate.right and keystate.left

    local walkingRight = (not both and keystate.right) or
                         (both and self.obj.lastDir == RIGHT)
    local walkingLeft = (not both and keystate.left) or
                        (both and self.obj.lastDir == LEFT)

    if walkingRight and self.obj.xspeed > -P_MAX_SPEED then
        self.obj.xspeed = self.obj.xspeed + self.obj.xacc*dt
        if self.obj.dir == LEFT then
            self.obj.dir = RIGHT
        end
    elseif walkingLeft and self.obj.xspeed < P_MAX_SPEED then
        self.obj.xspeed = self.obj.xspeed - self.obj.xacc*dt
        if self.obj.dir == RIGHT then
            self.obj.dir = LEFT
        end 
    elseif self.obj.jumping and (not walkingRight and not walkingLeft) then
        if self.obj.dir == LEFT then
            self.obj.xspeed = self.obj.xspeed - self.obj.xspeed*dt
        elseif self.obj.dir == RIGHT then
            self.obj.xspeed = self.obj.xspeed + self.obj.xspeed*dt
        end
    end

    self.obj.xspeed = cap(self.obj.xspeed, -P_MAX_SPEED, P_MAX_SPEED);
    if math.floor(self.obj.xspeed) == 0 and not (walkingLeft or walkingRight) then
        self.obj.xspeed = 0
    end
    self.obj.x = self.obj.x + self.obj.xspeed

    if not self.obj.onGround then
        --print("not on the ground")
        if self.obj.jumping then
           -- print("jumping so should be jumping")
            self.obj:updateJumping(dt)
        end
    end
    
    applyGravity(self.obj,dt)
    self.obj.y = self.obj.y + self.obj.yspeed
end
