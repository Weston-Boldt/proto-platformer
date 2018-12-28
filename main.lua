require('require_entities')
require("mainmenu")
require("ingame")
require("config")
require("meta-config")
require("util")
require("map")
require("globals")
require("resources")
print("HB_ATTACK = "..tostring(HB_ATTACK))

-- libs
bump = require 'libs.bump.bump'
anim8 = require 'libs.anim8.anim8'

-- todo rm me after debugging
lg = love.graphics

TILE_SIZE = 32
WIDTH = 640 
HEIGHT = 480

local MAX_FRAMETIME = 1/20
local MIN_FRAMETIME = 1/60


STATE_MAIN_MENU,STATE_INGAME = 0,1

-- init deltatime at 0
-- just to hopefully ignore a race condition
DeltaTime = 0
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

    loadResources()

    local sw = love.graphics.getWidth()/WIDTH/3
    local sh = love.graphics.getHeight()/HEIGHT/3
    love.window.setMode(WIDTH, HEIGHT)
    love.graphics.scale(sw,sh)


    mainmenu.enter()
end

function love.update(dt)
    if xacccool > 0 then
        xacccool = xacccool - dt
    end
    if yacccool > 0 then
        yacccool = yacccool - dt
    end
    gamestates[state].update(dt)
end

function love.draw()
    local lg = love.graphics;
    lg.setLineStyle('rough')
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

function updateSpecialKeys()
end

function updateKeys()
    if love.keyboard.isDown('lctrl') then
        handleMetaKeys()
    else 
        for action, key in pairs(config_keys) do
            if love.keyboard.isDown(key) then
                keystate[action] = true
            else
                keystate[action] = false
            end
        end
    end

    -- todo check joystick stuff
end
