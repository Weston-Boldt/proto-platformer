local bump = require'libs.bump.bump'
local Class = require'libs.hump.class'
local sti = require'libs.Simple-Tiled-Implementation.sti'
local Entities = require'entities'
local lg = love.graphics
local camera = require'libs.camera'
Map = {}
Map.__index = Map

LAST_SECTION = nil; -- idk if i want sections yet

function Map.create(level, player)
    local self = setmetatable({}, Map)  
    local levelFileName = "maps/map"..level..".lua";
    -- print(levelFileName)
    -- file = require "maps."..levelFileName
    -- self.file = love.filesystem.load(levelFileName)()
    -- print(self.file.ground0)
    -- print(self.file.ground1)
    
    -- love.filesystem.load("maps/map0.lua")
    self.mapData = sti(levelFileName, { 'bump' })
    print("map = "..tostring(self.mapData))
    self.world = bump.newWorld(32) 
    -- self.mapData:resize(
    --     lg.getWidth(),
    --     lg.getHeight()
    -- )
    self.mapData:bump_init(self.world)
    self.entities = nil
    Entities:enter()
    Entities = Entities

    self.objects = {}
    self.particles = {}
    self.enemies = {}
    self.npcs = {}
    self.items = {}
    self.world:add(
        player,
        player.x, player.y,
        player.img:getWidth(), player.img:getHeight()
    )
    self.player = player
    self.camera = camera
    return self
end

function Map:positionCamera(player, camera)
    local mapWidth = self.mapData.width * self.mapData.tilewidth -- get width in pixels
    local halfScreen =  love.graphics.getWidth() / 2

    if player.x < (mapWidth - halfScreen) then -- use this value until we're approaching the end.
        boundX = math.max(0, player.x - halfScreen) -- lock camera at the left side of the screen.
    else
        boundX = math.min(player.x - halfScreen, mapWidth - love.graphics.getWidth()) -- lock camera at the right side of the screen
    end

    self.camera:setPosition(boundX,0)
end

function Map:update(dt)
    self.mapData:update(dt)
    -- self:positionCamera(self.player, self.camera)
end

function Map:draw(trans_x, trans_y)
    print("trans_x = "..tostring(trans_x)..
        "translate_x"..tostring(-math.floor(translate_x)))
    self.camera:set()
    -- self.mapData:draw(-math.floor(translate_x), -math.floor(translate_y))
    self.mapData:draw(trans_x, trans_y)
    -- love.graphics.setColor(255, 0, 0)
    -- self.mapData:bump_draw(self.world)
    self.camera:unset()
    return true
end
