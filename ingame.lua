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

    player = Player.create(startx,starty,level)
    map = Map.create(level, player)
    print(map)
    ingame.newgame()
end

function ingame.update(dt)
    updateKeys()
    player:update(dt)
    translate_x = cap(player.x-WIDTH/2, 0, WIDTH)
    translate_y = cap(player.y-HEIGHT/2, 0, HEIGHT)
    map:update(dt)
end

function ingame.draw()
    -- #love.graphics.print("test")
    lg.translate(-math.floor(translate_x), -math.floor(translate_y))
    player:draw()
    map:draw()
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
