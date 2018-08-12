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

    maptest2 = cartographer.load(levelFileName)




    for index, value in ipairs(file.layers) do
        print("layer name = "..value.name)
    end 

    self.width = file.width
    self.height = file.height

    --[[
    self.frontBatch = lg.newSpriteBatch(
        self.assets.tilesheet
    )
    self.backBatch = lg.newSpriteBatch(
        self.assets.tilesheet
    )
    --]]

    self.viewX, self.viewY, self.viewW, self.viewH = 0, 0, 0, 0

    -- old map implementation
    -- love.filesystem.load("maps/map0.lua")
    -- self.mapData = sti(levelFileName, { 'bump' })
    -- print("map = "..tostring(self.mapData))
    self.world = bump.newWorld(32) 
    -- for the hit boxes to collide freely
    self.hitBoxWorld = bump.newWorld(32)
    -- self.mapData:resize(
    --     lg.getWidth(),
    --     lg.getHeight()
    -- )
    -- self.mapData:bump_init(self.world)

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
    self.populate()
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
end

function Map:update(dt)
    maptest2:update(dt)
    -- self.mapData:update(dt)
end

function Map:draw(trans_x, trans_y)
    --print("trans_x = "..tostring(trans_x)..
    --    "translate_x"..tostring(-math.floor(translate_x)))
    -- self.mapData:draw(-math.floor(translate_x), -math.floor(translate_y))
    maptest2:draw()
    -- self.mapData:draw(trans_x, trans_y)
    -- love.graphics.setColor(256, 0, 0)
    -- self.mapData:bump_draw(self.world)
    return true
end
