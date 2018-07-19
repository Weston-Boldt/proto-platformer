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
    player = Player.create(startx,starty,level)
    map = Map.create(level, player)
    print(map)
    ingame.newgame()
end

function ingame.update(dt)
    updateKeys()
    player:update(dt)
    map:update(dt)
end

function ingame.draw()
    -- #love.graphics.print("test")
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
