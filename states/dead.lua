local Class = require'libs.hump.class'

StDead = Class {
    __includes = StBase
}

function StDead:init(obj)
    self = StBase.init(self, obj, beforeFn, afterFn)
    self.name = 'dead'
    return self
end

function StDead:enter(dt)
    self.obj.active = false
end

function StDead:updateDead(dt)
    
end
