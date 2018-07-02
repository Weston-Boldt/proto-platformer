require("player")
require("mainmenu")
require("ingame")
require("config")
require("util")
WIDTH = 256
HEIGHT = 200

local MAX_FRAMETIME = 1/20
local MIN_FRAMETIME = 1/60


STATE_MAIN_MENU,STATE_INGAME = 0,1

gamestates = {
    [STATE_MAIN_MENU]=mainmenu,
    [STATE_INGAME]=ingame,
}

-- global state index
-- starts at nil
state = nil;

function love.load()
    love.graphics.setBackgroundColor(0, 0, 0)
    love.graphics.setDefaultFilter("nearest", "nearest")

    mainmenu.enter()
end

local timesHit = 0;
local deltaTimeToSHow = 0;
function love.update(dt)
    if timesHit > 100 then
        timesHit = 0
    end
    if timesHit % 20 == 0 then
        deltaTimeToShow = dt
    end
    timesHit = timesHit + 1
    gamestates[state].update(dt)
end

function love.draw()
    -- love.graphics.print(deltaTimeToShow)
    -- love.graphics.print(timesHit)
    gamestates[state].draw()
end

function love.keypressed(k, uni)
    if k == "escape" then
        love.event.push("quit")
    end
    gamestates[state].keypressed(k, uni)
end

function love.textinput(text)
end

function updateKeys()
    for action, key in pairs(config_keys) do
        if love.keyboard.isDown(key) then
            keystate[action] = true
        else
            keystate[action] = false
        end
    end

    -- todo check joystick stuff
end
