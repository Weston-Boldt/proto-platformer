local Class = require'libs.hump.class'

StLaunching = Class {
    __includes = StBase
}

function StLaunching:init(obj)
    self = StBase.init(self, obj)
    return self
end

function StLaunching:enter()
    local obj = self.obj
    obj.canAttack = false

    obj.launchHitBox = HitBox(obj,
        obj.x, obj.y,
        -- these will need to shift likely
        SZ_DBL_TIRE, SZ_DBL_TILE,
        true, true
    )

    -- if they hit a wall on their left, they should be 
    -- facing the right direciton after the launch so set that now
    -- as it's probably the most appropriate time
    if not inTable(self.attackDir, {AD_UP, AD_DOWN}) then
        self.dir = self.dir * -1
    end

    Timer.after(2, function()
        obj.needToLaunch = false
        obj.canAttack = true

        obj:detachHitBox('launchHitBox')

        self:exit()

    end)
end

function StLaunching:update(dt)
    -- lol todo abstract this into a data file
    local speed = 500
    self.x = self.x + math.sin(self.launchAngle) * dt * speed
    self.y = self.y + math.cos(self.launchAngle) * dt * speed
end

function StLaunching:exit(obj)
    -- clear the state key on the obj
    -- which the obj will catch and then
    -- reset the obj.state to another state
    self.obj.state = nil
end
