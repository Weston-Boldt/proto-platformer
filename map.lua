local bump = require'libs.bump.bump'
local entities = require'entities'
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
    entities:add(entity)
    self.world:add(
        entity,
        entity.x, entity.y,
        entity.w, entity.h
    )
end

function Map:addEntityToHitBoxWorld(hitBox)
    entities:add(hitBox)
    self.hitBoxWorld:add(
        hitBox,
        hitBox.x, hitBox.y,
        hitBox.w, hitBox.h
    )
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
--]]
function Map:populate()
    -- get all the stuff in spawn points
    for key, value in pairs(
        self.spawnPoints.objects
    ) do
        local obj = value
        -- attempt to construct objects (if they exist)
        for key, value in pairs(obj) do
            print(tostring(key).." = "..tostring(value))
            if key == "name" then
                local new_entity = self:getObjectToSpawn(value)(obj.x, obj.y)
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
    entities:update(dt)
    self.mapData:update(dt)
end

function Map:draw(trans_x, trans_y)
    -- todo fixme, this can be handled a bit easier later on
    self.furtherMostBackGroundLayer:draw()
    self.farBackGroundLayer:draw()
    self.backGroundLayer:draw()
    self.foreGroundLayer:draw(-math.floor(translate_x), -math.floor(translate_y))
    self.frontLayer:draw()
    entities:draw()
    return true
end
