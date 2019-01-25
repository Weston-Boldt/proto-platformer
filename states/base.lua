local Class = require'libs.hump.class'

StBase = Class {
}

function StBase:init(obj, beforeFn, afterFn)
    self.name = 'run';
    self.obj = obj;
    self.beforeFn = beforeFn;
    self.afterFn = afterFn;
    return self
end

function StBase:enter(dt)
    print("self.name = "..self.name)
    self.obj.state = self.name
end

function StBase:exit(dt)
    print("self.name = "..self.name)
    self.obj.state = nil
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
