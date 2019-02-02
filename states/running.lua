local Class = require'libs.hump.class'

StRunning = Class {
    __includes = StBase
}

function StRunning:init(obj, beforeFn, afterFn)
    self = StBase.init(self, obj, beforeFn, afterFn)
    self.name = 'run';
    return self
end

function StRunning:update(dt)
    applyFriction(self.obj,dt)

    if self.obj.moving then
        self.obj.xspeed = self.obj.xspeed + ((self.obj.xacc*dt) * self.obj.dir) 
    end

    self.obj.xspeed = cap(self.obj.xspeed, -MAX_SPEED, MAX_SPEED)
    self.obj.yspeed = self.obj.yspeed + self.obj.gravity * dt

    self.obj.x = self.obj.x + self.obj.xspeed
    self.obj.y = self.obj.y + self.obj.yspeed
end
