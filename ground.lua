local Class = require'libs.hump.class'
local Entity = require'entity'
-- local lg = love.graphics

local Ground = Class{
    -- inherit entity
    __includes = Entity
}

function Ground:init(--[[world-,-]]x,y,w,h)
    Entity.init(self,--[[world,--]]x,y,w,h)

    -- self.world:add(self, self:getRect())
end

function Ground:draw()
    -- place holder
--     lg.rectangle('fill', self.getRect())
end

return Ground
