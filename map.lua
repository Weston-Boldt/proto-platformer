Map = {}
Map.__index = Map

LAST_SECTION = nil; -- idk if i want sections yet

local lg = love.graphics

function Map.create(level, player)
    local self = setmetatable({}, Map)  
    local levelFileName = "map"..level..".lua";
    print(levelFileName)
    -- file = require "maps."..levelFileName
    self.file = love.filesystem.load("maps/"..levelFileName)()
    print(self.file.ground0)
    print(self.file.ground1)
    
    -- love.filesystem.load("maps/map0.lua")
    self.world = bump.newWorld(16) 
    self.objects = {}
    self.particles = {}
    self.enemies = {}
    self.npcs = {}
    self.items = {}
    --map:add(
    --)
    self.world:add(
        player,
        player.x, player.y,
        player.img:getWidth(), player.img:getHeight()
    )
    -- map.file = file;
    -- todo make a function to load map assets
    self.world:add(
        self.file.ground0, 120, 360, 640, 16
    )
    self.world:add(
        self.file.ground1, 0, 448, 640, 32
    )
    return self
end

function Map:update(dt)
end

function Map:draw()
    love.graphics.rectangle('fill', self.world:getRect(self.file.ground0))
    love.graphics.rectangle('fill', self.world:getRect(self.file.ground1))
end
