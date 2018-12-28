require("util")

meta_keys = {
    reloadConf = 'r',
    reloadResources = 't',
}

metaFunctions = {
    reloadConf = function()
    end,

    reloadResources = function()
        -- note this doesn't actually do anything, but it is the right idea
        loadResources()
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
