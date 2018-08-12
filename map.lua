local bump = require'libs.bump.bump'
local Class = require'libs.hump.class'
local sti = require'libs.Simple-Tiled-Implementation.sti'
local cartographer = require'libs.cartographer.cartographer'
local lg = love.graphics
Map = {}
Map.__index = Map

LAST_SECTION = nil; -- idk if i want sections yet

function Map.create(level, map, player)
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

    local file = love.filesystem.load(levelFileName)()

    --[[
    for index, value in ipairs(file.layers) do
        print("layer name = "..value.name)
    end 
    --]]

    self.width = file.width
    self.height = file.height
    self.viewX, self.viewY, self.viewW, self.viewH = 0, 0, 0, 0

    -- old map implementation
    -- love.filesystem.load("maps/map0.lua")
    self.mapData = sti(levelFileName, { 'bump' })
    for key, val in pairs(self.mapData.layers.player_spawn_point.objects[1]) do
        print(tostring(key).." = "..tostring(val))
    end
    print("\tbreak")
    for key2, val2 in pairs(self.mapData.layers.player_spawn_point.objects) do
        print(tostring(key2).." = "..tostring(val2))
        local obj = val2
        print(obj.properties)
        print("break\n")
        for key3, val3 in pairs(obj.properties) do
        print(tostring(key3).." = "..tostring(val3))
        end
    end

    --[[
    for key, val in pairs(self.mapData.layers.player_spawn_point.objects[1].properties) do
        print(tostring(key).." = "..tostring(val))
    end
    --]]
    -- print("map = "..tostring(self.mapData))
    self.world = bump.newWorld(32) 
    -- for the hit boxes to collide freely
    self.hitBoxWorld = bump.newWorld(32)
    -- self.mapData:resize(
    --     lg.getWidth(),
    --     lg.getHeight()
    -- )
    self.mapData:bump_init(self.world)

    self.objects = {}
    self.particles = {}
    self.enemies = {}
    self.npcs = {}
    self.items = {}
    self.world:add(
        player,
        player.x, player.y,
        32, 64
        -- player.img:getWidth() * 25, player.img:getHeight()
    )

    self.hitBoxWorld:add(
        player.hitBox,
        player.hitBox.x,
        player.hitBox.y,
        player.hitBox.w,
        player.hitBox.h
    )

    self.player = player
    
    --[[
    print("map data = ")
    for key, value in pairs(self.mapData) do
        print("\t "..tostring(key).."value = "..tostring(value))
    end
    print("map objects = ")
    for key, value in pairs(self.mapData.objects) do
        print("\t "..tostring(key).."value = "..tostring(value))
        for key, value in pairs(value) do
            print("\t\t key = "..tostring(key).."value"..tostring(value))
        end
    end
    --]]
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

function Map:populate()
    for key, value in pairs(
        self.mapData.layers.player_spawn_point.objects
    ) do
        local obj = value
        for k, v in pairs(obj.properties) do
            if v == "player" then
                self.player.x = obj.x
                self.player.y = obj.y
            end
        end
    end
end

function Map:update(dt)
    --maptest2:update(dt)
    self.mapData:update(dt)
end

function Map:draw(trans_x, trans_y)
    --print("trans_x = "..tostring(trans_x)..
    --    "translate_x"..tostring(-math.floor(translate_x)))
    --print("mapData = "..dump(self.mapData.layers["Tile Layer 1"]))
    self.mapData.layers["Tile Layer 1"]:draw(-math.floor(translate_x), -math.floor(translate_y))
    -- self.mapData:draw(-math.floor(translate_x), -math.floor(translate_y))
    -- self.mapData:draw(trans_x, trans_y)
    -- love.graphics.setColor(256, 0, 0)
    -- self.mapData:bump_draw(self.world)
    return true
end
