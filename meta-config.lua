require("util")

meta_keys = {
    reloadConf = 'r',
    reloadResources = 't',
}

metaFunctions = {
    reloadConf = function()
    end,

    reloadResources = function()
        loadResources()
    end,
}

function handleMetaKeys()
    for action, key in pairs(meta_keys) do
        local fn = metaFunction
        if not fn == nil then
            fn()
        end
    end
end
