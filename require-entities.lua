function recursiveRequire(folder,tree)
    local tree = tree or {}
    for i,file in ipairs(love.filesystem.getDirectoryItems(folder)) do
        local filename = folder .. "/" .. file
        local dirInfo = love.filesystem.getInfo(filename)
        if dirInfo.type == "directory" then
            recursiveRequire(filename)
        elseif file:match(".lua") == ".lua"
        and not file:match(".swp") then
            filename = filename:gsub(".lua","")
            require(filename)
        end
    end

    return tree
end

return  {
    recursiveRequire('entities');
    recursiveRequire('triggers');
    recursiveRequire('states');
}
