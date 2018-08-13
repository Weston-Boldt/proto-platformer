entities = require'entities'
ingame = {
}

TEST_LEVEL = 0;
LEVEL_START = 1;
-- todo fixme
-- PLACEHOLDER VALUES
level = TEST_LEVEL;
map = LEVEL_START;

local TILE_HEIGHT = 32
local TILE_WIDTH = 32

local lg = love.graphics
function ingame.enter()
    self = setmetatable({}, Map)

    state = STATE_INGAME
    translate_x, translate_y = 0, 0

    -- player = Player.create(startx,starty,level)
    map = Map.create(level, map,player)
    player = map.player
    -- entities:add(player)
    -- entities:add(player.hitBox)
    -- print(map)
    ingame.newgame()
end

function ingame.update(dt)
    -- print("entities length"..tostring(#entities.entityList))
    --print("hitbox entities length"..tostring(#hitboxEntities.entityList))
    updateKeys()
    -- entities:update(dt)
    map:update(dt)
    -- player:update(dt)
    -- translate_x = cap(player.x-WIDTH/2, 0, WIDTH)
    --[[
    print("map.width = "..tostring(map.width))
    print("map.mapData.width = "..tostring(map.mapData.width))
    --]]
    -- local mapWidth = map.width
    -- local mapWidth = map.mapData.width * map.mapData.tilewidth
    local mapWidth = map.width * TILE_WIDTH
    local halfScreen = WIDTH / 2

    if player.x < (mapWidth - halfScreen) then
        translate_x = cap(
            player.x - halfScreen, 0, mapWidth
        )
    else 
        translate_x = cap(
            player.x - halfScreen, 0, mapWidth - WIDTH
        )
    end
    -- translate_y = cap(player.y-HEIGHT/2, 0, HEIGHT)
    translate_y = player.y-HEIGHT/2
end

function ingame.draw()
    local trans_x = -math.floor(translate_x) 
    local trans_y = -math.floor(translate_y)
    lg.translate(trans_x, trans_y)
    map:draw(trans_x, trans_y)
    -- player:draw()
end

function ingame.keypressed(k, uni)
    for action, key in pairs(config_keys) do
        if k == key then
            player:action(action)
        end
    end
end

function ingame.newgame()
end
