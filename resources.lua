local lg = love.graphics
img = {
}
quad = {} -- dont need
font = {} --probably dont need
local snd = {} -- will need

-- this could be not hard coded but
-- but for now it should be fine
local LEVEL_ASSET_PATHS = {
    -- test / debug level 
    level_0 = {
        -- unfortunate naming scheme
        map_1 = {
            tilesheet = 'assets/first_sprite_sheet.png',
        }
    },
    -- TODO FIXME
    -- uncomment when these files exist
    --[[
    lovel_1 = {
        map_1 = {
            -- tilesheet = assets/level_1/map_1/tilesheetet.png
            tilesheet = '',
        },
    },
    level_2 = {
        map_2 = {
            -- tilesheet = assets/level_2/map_1/tilesheetet.png
            tilesheet = '',
        },
    },
    level_3 = {
        map_3 = {
            -- tilesheet = assets/level_3/map_1/tilesheetet.png
            tilesheet = '',
        },
    },
    level_4 = {
        map_4 = {
            -- tilesheet = assets/level_4/map_1/tilesheetet.png
            tilesheet = '',
        },
    },
    level_5 = {
        map_4 = {
            -- tilesheet = assets/level_4/map_1/tilesheetet.png
            tilesheet = '',
        },
    },
    --]]
}

function loadResources()
    for levelName, level in pairs(LEVEL_ASSET_PATHS) do
        img[levelName] = {}
        quad[levelName] = {}
        -- print("levelName = "..levelName)
        for mapName, map in pairs(level) do
            img[levelName][mapName] = {}
            quad[levelName][mapName] = {}
            -- print("map_name = "..mapName)
            local fileName = LEVEL_ASSET_PATHS[levelName][mapName].tilesheet
            -- print('filename = '..fileName)

            img[levelName][mapName].tilesheet = lg.newImage(
                LEVEL_ASSET_PATHS[levelName][mapName].tilesheet
            );
            quad[levelName][mapName].tile = {}
            local id = 1
            for iy = 1, 32 do
                for ix = 1, 32 do
                    quad[levelName][mapName].tile[id] = lg.newQuad(ix*32, iy*32, 32, 32, getSize(
                        img[levelName][mapName].tilesheet
                    ))
                    id = id + 1
                end
            end
        end
    end

end

function getSize(img)
    return img:getWidth(), img:getHeight()
end

