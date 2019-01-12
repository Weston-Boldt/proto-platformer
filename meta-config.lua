require("util")

local hasDataFile = {
    'entities',

}
meta_keys = {
    reloadConf = 'r',
    reloadDataFiles = 't',
}

metaFunctions = {
    reloadConf = function()
    end,

    reloadDataFiles = function()
        -- grab the global ingame table
        local map = map
        if not map then
            print('no map obj')
        end
        for key, value in pairs(map) do
            if inTable(key, hasDataFile) then
                local collection = map[key]
                for key, obj in pairs(collection.entityList) do
                    obj:reloadData()
                end
            end
        end
    end,
}

function handleMetaKeys()
    for action, key in pairs(meta_keys) do
        if love.keyboard.isDown(key) then
            local fn = metaFunctions[action]
            if fn then
                fn()
            end
        end
    end
end
