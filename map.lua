local bump = require'libs.bump.bump'
local Entities = require'entities'
print("Entities = "..tostring(Entities))
local Class = require'libs.hump.class'
local sti = require'libs.Simple-Tiled-Implementation.sti'
local cartographer = require'libs.cartographer.cartographer'
local lg = love.graphics
Map = {}
Map.__index = Map

LAST_SECTION = nil; -- idk if i want sections yet

function Map.create(level, map)
    local self = setmetatable({}, Map)  
    self.levelNumber = level
    self.mapNumber = map
    self.assets = img["level_"..tostring(self.levelNumber)]
        ["map_"..tostring(self.mapNumber)]


    -- todo fixme
    -- we want the maps to be like this
    -- but first i need to get map loading working
    -- maps
    -- |         |        |
    -- \level_0  \level_1 \level_2
    --  |         |        |
    --  \ room_0  \ room_0 \ room_0
    --    room_1    room_1   room_2
    local levelFileName = "maps/map"..level..".lua";

    self.mapData = sti(levelFileName, { 'bump' })
    for key, value in pairs(self.mapData.layers) do
        print(tostring(key).." = "..tostring(value))
    end

    -- set layer objects on to the self obj
    self:prepLayers(self.mapData.layers)

    self.width = self.mapData.width
    self.height = self.mapData.height

    self.world = bump.newWorld(32) 
    self.hitBoxWorld = bump.newWorld(32)
    self.mapData:bump_init(self.world)

    self.entities = Entities(self)
    print("entities = "..tostring(self.entities))
    print("entities.entityList = "..tostring(self.entities.entityList))
    self.triggers = Entities(self)
    print("triggers = "..tostring(self.triggers))
    print("triggers.entitylist = "..tostring(self.triggers.entityList))

    self.objects = {}
    self.particles = {}
    self.enemies = {}
    self.npcs = {}
    self.items = {}

    self:populate()
    return self
end

function Map:prepLayers(layers)
    -- obj layers
    self.levelTriggers = self.mapData.layers['level_triggers']
    self.spawnPoints = self.mapData.layers['spawn_points'];
    -- sprite layers
    self.frontLayer = self.mapData.layers['front_sprite']
    self.foreGroundLayer = self.mapData.layers['foreground_sprite']
    self.backGroundLayer = self.mapData.layers['background_sprite']
    self.farBackGroundLayer = self.mapData.layers['far_background_sprite']
    self.furtherMostBackGroundLayer = self.mapData.layers['further_most_background_sprite']
end

function Map:get(x,y)
    if x < 0 or y < 0 or x > self.width or y > self.height then
        return 0
    else
        return self.data[y*self.width+x+1]
    end
end

function Map:addEntityToWorld(entity)
    self.entities:add(entity)
    self.world:add(
        entity,
        entity.x, entity.y,
        entity.w, entity.h
    )
end

function Map:addEntityToHitBoxWorld(hitBox)
    self.entities:add(hitBox)
    self.hitBoxWorld:add(
        hitBox,
        hitBox.x, hitBox.y,
        hitBox.w, hitBox.h
    )
end

function Map:getTriggerToSpawn(TriggerName)
    Triggers = {
        MapEnd = function(x,y,w,h)
            self.MapEnd = MapEnd:init(x,y,w,h)
            self.triggers:add(MapEnd)
        end,
    }
end

function Map:getObjectToSpawn(objName)
    print("objName = "..tostring(objName))
    objects = {
        Player = function (x, y)
            self.player = Player:init(x,y)
            self:addEntityToWorld(self.player)
            self:addEntityToHitBoxWorld(self.player.hitBox)
            return player
        end,
    }
    local returnObject = objects[objName]
    -- didn't find a callable object
    -- return a closure with nil to avoid
    -- a lua err
    if not returnObject then
        return function ()
            return nil
        end
    else 
        return objects[objName]
    end
end

--[[
@description
    this function loads objects according to there
    placement on the tiled map

@future
    we will want to be getting towards this
        object = _G[type](arguments)
    as the if else 
    here is dirty and more than likely
    hard to imagine
@update 
    i actually prefer this way of adding entities for now, and im not
    super excited to move into the _G[type] method so i probably wont be
    using it 
--]]
function Map:populate()
    for key, value in pairs(
        self.spawnPoints.objects
    ) do
        local obj = value
        if obj.name then
            print("obj.name = "..tostring(obj.name))
            local new_entity = self:getObjectToSpawn(obj.name)(obj.x, obj.y)
        end
    end

    for key, value in pairs(
        self.levelTriggers.objects
    ) do
        local trigger = value
        if trigger.name then
            print("hey found a trigger to load")
        end
    end
end


--[[
(RectA.Left < RectB.Right && RectA.Right > RectB.Left &&
     RectA.Top > RectB.Bottom && RectA.Bottom < RectB.Top ) 
-- dirty rect to avoid creating a "world"
--]]
function Map:reachedEnd()
    for key, obj in pairs(self.levelTriggers.objects) do
        if obj.name == "map_end" or obj.name == "level_end" then
            if
                collX(
                    self.player.x, self.player.x+self.player.h,
                    obj.x, obj.x + obj.width     
                )
            and
                collY(
                    self.player.y,  self.player.y + self.player.h,
                    obj.y, obj.y + obj.height
                )
            then
                print("got a collision A")
            end
        end 
    end
end

function Map:update(dt)
    if (self.player.Respawn) then
        self.doRespawn = false
        self.world:move(
            player,
            self.player.spawnX,
            self.player.spawnY
        )
        self.hitBoxWorld:move(
            player.hitBox,
            self.player.hitBox.x,
            self.player.hitBox.y
        )
    end

    self:reachedEnd()
    self.entities:update(dt)
    self.triggers:update(dt)
    self.mapData:update(dt)
end

function Map:draw(trans_x, trans_y)
    -- todo fixme, this can be handled a bit easier later on
    self.furtherMostBackGroundLayer:draw()
    self.farBackGroundLayer:draw()
    self.backGroundLayer:draw()
    self.foreGroundLayer:draw(-math.floor(translate_x), -math.floor(translate_y))
    self.frontLayer:draw()
    self.entities:draw()
    self.triggers:draw()
    return true
end
