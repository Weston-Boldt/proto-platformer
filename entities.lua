local Class = require'libs.hump.class'
--[[
todo instantiate this
local Class = require'libs.hump.class'
-- collection of entities for a map to have (or world)
-- thanks osm stuidios tutorial
Entities = Class{
}

function Entities:init()
    self.active = true
    self.map = nil
    self.entityList = {}
    return self
end
local Class = require'libs.hump.class'
-- collection of entities for a map to have (or world)
-- thanks osm stuidios tutorial
Entities = Class{
}
--]]
-- collection of entities for a map to have (or world)
-- thanks osm stuidios tutorial
local Entities = Class{}

function Entities:init(map)
    print("top of entities:init")
    self.active = true
    -- world = nil,
    self.map = map
    -- todo total hack,
    -- but we don't really need to deal with it
    self.entityList = {}
--     return self
end

function Entities:enter(--[[world,--]]map)
    self:clear()

    --self.world = world
    self.map = map
end

function Entities:add(entity)
    -- print("mapend = "..tostring(entity))
    table.insert(self.entityList, entity)
end

function Entities:addMany(entities)
    for _, entity in pairs do
        self:add(entity)
    end
end

function Entities:removeAt(index)
  table.remove(self.entityList, index)
end

function Entities:remove(entity)
  for i, e in ipairs(self.entityList) do
    if e == entity then
      table.remove(self.entityList, i)
      return
    end
  end
end

function Entities:clear()
    -- self.world = nil
    self.map = nil

    self.entityList = {}
end

function Entities:draw()
  for i, e in ipairs(self.entityList) do
    e:draw(i)
  end
end

function Entities:update(dt)
  for i, e in ipairs(self.entityList) do
    e:update(dt, i)
  end
end

return Entities
