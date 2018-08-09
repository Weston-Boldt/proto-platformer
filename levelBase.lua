local bump = require'libs.bump.bump'
local Class = require'libs.hump.class'
local sti = require'libs.sti.sti'
local Entities = require'entities'

local LevelBase = Class{
    init = function(self, mapFile)
        self.map = sti(mapFile, { 'bump' })
        self.world = bump.newWorld(32)
        self.map:resize(
            love.graphics.getWidth(),
            love.graphics.getHeight()
        )

        self.map:bump_init(self.world)

        Entities:enter()
    end;

    Entities = Entities;
    -- camera = camera
}
