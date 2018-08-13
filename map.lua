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
    self.width = self.mapData.width
    self.height = self.mapData.height
    --[[
    for key, val in pairs(self.mapData) do
        print(tostring(key).." = "..tostring(val))
    end
    --]]
    --[[
    print("\tbreak")
    for key2, val2 in pairs(self.mapData.layers.spawn_points.objects) do
        print(tostring(key2).." = "..tostring(val2))
        local obj = val2
        print(obj.properties)
        print("break\n")
        for key3, val3 in pairs(obj.properties) do
        print(tostring(key3).." = "..tostring(val3))
        end
    end
    --]]

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

function Map:get(x,y)
    if x < 0 or y < 0 or x > self.width or y > self.height then
        return 0
    else
        return self.data[y*self.width+x+1]
    end
end

-- currently broken
function Map:getObjectToSpawn(objName)
    print("objName = "..tostring(objName))
    objects = {
        Player = function (x, y)
            self.player = Player:init(x,y)
            entities:add(self.player)
            self.world:add(
                self.player,
                self.player.x, self.player.y,
                32, 64
                -- player.img:getWidth() * 25, player.img:getHeight()
            )

            self.hitBoxWorld:add(
                self.player.hitBox,
                self.player.hitBox.x,
                self.player.hitBox.y,
                self.player.hitBox.w,
                self.player.hitBox.h
            )
            return player
        end,
    }
    local returnObject = objects[objName]
    print("return object = "..tostring(returnObject))
    return objects[objName]
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
    for key, value in pairs(
        self.mapData.layers.spawn_points.objects
    ) do
        local obj = value
        for key, value in pairs(obj.properties) do
            local new_entity = self:getObjectToSpawn(value)(obj.x, obj.y)
            --[[
            print(tostring(key).." = "..tostring(value))
            if value == "Player" then
                self.player = Player:init(obj.x, obj.y)
                entities:add(self.player)
                -- entities:add(player.hitBox)
                self.world:add(
                    self.player,
                    self.player.x, self.player.y,
                    32, 64
                    -- player.img:getWidth() * 25, player.img:getHeight()
                )

                self.hitBoxWorld:add(
                    self.player.hitBox,
                    self.player.hitBox.x,
                    self.player.hitBox.y,
                    self.player.hitBox.w,
                    self.player.hitBox.h
                )
            end
            --]]
        end
    end
end

function Map:update(dt)
    entities:update(dt)
    self.mapData:update(dt)
end

function Map:draw(trans_x, trans_y)
    -- todo fixme, this can be handled a bit easier later on
    self.mapData.layers["Tile Layer 1"]:draw(-math.floor(translate_x), -math.floor(translate_y))
    entities:draw()
    return true
end
