-- collection of entities for a map to have (or world)
-- thanks osm stuidios tutorial
local Entities = {
    active = true,
    -- world = nil,
    map = nil,
    entityList = {}
}

function Entities:enter(--[[world,--]]map)
    self:clear()

    --self.world = world
    self.map = map
end

function Entities:add(entity)
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