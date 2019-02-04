local Class = require'libs.hump.class'

StDamage = Class {
    __includes = StBase
}

function StDamage:init(obj, beforeFn, afterFn)
    self = StBase.init(self, obj, beforeFn, afterFn)
    self.name = 'damage'
    return self
end

function StDamage:update(dt)
    if self.obj.damageTime > 0 then
        self.obj.damageTime = self.obj.damageTime - dt
    else
        self:exit()
    end
end
