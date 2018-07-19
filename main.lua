require("player")
require("mainmenu")
require("ingame")
require("config")
require("util")
require("map")

-- libs
bump = require 'libs.bump.bump'

WIDTH = 640
HEIGHT = 480

local MAX_FRAMETIME = 1/20
local MIN_FRAMETIME = 1/60


STATE_MAIN_MENU,STATE_INGAME = 0,1
local AXIS_COOLDOWN = 0.2
local xacc = 0
local yacc = 0
local xacccool = 0
local yacccool = 0

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
    local sw = love.graphics.getWidth()/WIDTH/3
    local sh = love.graphics.getHeight()/HEIGHT/3
    love.window.setMode(WIDTH, HEIGHT)
    love.graphics.scale(sw,sh)


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
    if xacccool > 0 then
        xacccool = xacccool - dt
    end
    if yacccool > 0 then
        yacccool = yacccool - dt
    end
    gamestates[state].update(dt)

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
