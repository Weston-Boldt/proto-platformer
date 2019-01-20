local Class = require'libs.hump.class'

StBase = Class {
}

function StBase:init(obj, beforeFn, afterFn)
    self.name = 'Running';
    self.obj = obj;
    self.beforeFn = beforeFn;
    self.afterFn = afterFn;
    return self
end

function StBase:enter(dt)
end

function StBase:exit(dt)
end

function StBase:before(dt)
    call(self.beforeFn(dt, self.obj))
end

function StBase:after(dt)
    call(self.afterFn(dt, self.obj))
end

function StBase:update(dt)
    self:before(dt)
    self:after(dt)
end
