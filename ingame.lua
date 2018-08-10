ingame = {}
-- todo fixme
-- fill these out
startx = 40;
starty = 40;
level = 0;
-- idk if i even want sections yet!
section = 0;

local lg = love.graphics
function ingame.enter()
    state = STATE_INGAME
    translate_x, translate_y = 0, 0

    -- player = Player.create(startx,starty,level)
    player = Player:init(startx, starty)
    map = Map.create(level, player)
    -- print(map)
    ingame.newgame()
end

function ingame.update(dt)
    updateKeys()
    player:update(dt)
    -- translate_x = cap(player.x-WIDTH/2, 0, WIDTH)
    local mapWidth = map.mapData.width * map.mapData.tilewidth
    local halfScreen = WIDTH / 2
    print("map width = "..tostring(mapWidth) .. "player.x = "..tostring(player.x))
    --  TODO FACTOR ME
    --  these values probably dont need to be global
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
    map:update(dt)
end

function ingame.draw()
    local trans_x = -math.floor(translate_x) 
    local trans_y = -math.floor(translate_y)
    lg.translate(trans_x, trans_y)
    map:draw(trans_x, trans_y)
    player:draw()
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
