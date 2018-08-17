local Class = require'libs.hump.class'
local Trigger = require'trigger'

MapEnd = Class{
    _includes = Trigger
}

function MapEnd:init(x,y,w,h)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
end
