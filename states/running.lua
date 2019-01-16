StRunning = Class {
}

function StRunning:init(obj)
    return {
        name = 'Running',
    }
end

function StateRunning:update(dt)
    applyFriction(self,dt)

    if self.moving then
        self.xspeed = self.xspeed + ((self.xacc*dt) * self.dir) 
    end

    self.xspeed = cap(self.xspeed, -MAX_SPEED, MAX_SPEED)
    self.yspeed = self.yspeed + self.gravity * dt

    self.x = self.x + self.xspeed
    self.y = self.y + self.yspeed
end
