ingame = {}
-- todo fixme
-- fill these out
startx = 0;
starty = 0;
level = 0;

function ingame.enter()
    state = STATE_INGAME
    player = Player.create(startx,starty,level)
    ingame.newgame()
end

function ingame.update(dt)
    updateKeys()
    player:update(dt)
end

function ingame.draw()
    -- #love.graphics.print("test")
    player:draw()
end

function ingame.keypressed(k, uni)
    for a, key in pairs(config_keys) do
        if k == key then
            player:action(key)
        end
    end
end

function ingame.newgame()
end
