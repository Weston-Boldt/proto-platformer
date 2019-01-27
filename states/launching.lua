local Class = require'libs.hump.class'
local Timer = require'libs.hump.timer'

StLaunching = Class {
    __includes = StBase
}

function StLaunching:init(obj)
    self = StBase.init(self, obj)
    self.name = 'launch'
    return self
end

function StLaunching:enter()
    local obj = self.obj
    self.obj.canAttack = false

    self.obj.launchHitBox = HitBox(self.obj,
        self.obj.x, self.obj.y,
        -- these will need to shift likely
        SZ_TILE, SZ_DBL_TILE,
        true, true
    )

    -- if they hit a wall on their left, they should be 
    -- facing the right direciton after the launch so set that now
    -- as it's probably the most appropriate time
    if not inTable(self.obj.attackDir, {AD_UP, AD_DOWN}) then
        self.obj.dir = self.obj.dir * -1
    end

    Timer.after(2, function()
        self.obj.needToLaunch = false
        self.obj.canAttack = true

        self.obj:detachHitBox('launchHitBox')

        self:exit()

    end)
    self.obj.state = self.name
end

function StLaunching:update(dt)
    -- lol todo abstract this into a data file
    local speed = 500
    self.obj.x = self.obj.x + math.sin(self.obj.launchAngle) * dt * speed
    self.obj.y = self.obj.y + math.cos(self.obj.launchAngle) * dt * speed
end
