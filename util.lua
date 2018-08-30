function applyFriction(object,dt)
    object.xspeed = object.xspeed * (1 - math.min(dt * object.friction, 1))
    object.yspeed = object.yspeed * (1 - math.min(dt * object.friction, 1))
end

function collX(objALeft,objARight,objBLeft,objBRight)
    --[[
    print("a left = "..tostring(objALeft).." a right = "..tostring(objARight)..
            " b left"..tostring(objBLeft).. " b right"..tostring(objBRight))
    --]]
    if
        objALeft <= objBRight and
        objARight >= objBLeft
    then
        return true
    end

    return false
end

function collY(objATop, objABottom, objBTop, objBBottom)
    -- todo fixme
    --  i think this werks, but the y values go from
    --  0 1 2
    --  1
    --  2
    --  so it may not need to be flip
    if 
        objATop < objBBottom and
        objABottom > objBTop
    then
        return true
    end
    return false
end

function collideX(object)
    if object.xspeed == 0 then
        return
    end

    local collision = false

    -- last object collision detected
    local last

    for _, yoffset in ipairs({object.corners[3], (object.corners[3]+object.corners[4])/2, object.corners[4]}) do
        for _, xoffset in ipairs({object.corners[1], object.corners[2]}) do
            -- todo get map collisions with solid tiles
            -- if map:collidePoints(object.x+xoffset, object.y+yoffset) then
            -- collision = true
            -- end
            -- and also todo collide with objects
        end
    end
end

function collideY(object)
    -- exit early if you are stopped 
    if object.yspeed == 0 then
        return
    end

    local collision = false
    for _, yoffset in ipairs({object.corners[3], object.corners[4]}) do
        for _, xoffset in ipairs({object.corners[1], object.corners[2]}) do
            -- todo get map collisions with solid tiles
            -- if map:collidePoints(object.x+xoffset, object.y+yoffset) then
            -- collision = true
            -- end
            -- and also todo collide with objects
        end
    end
end

function cap(val, min, max)
    return math.max(math.min(val, max), min)
end

function dump(obj,counter)
    if not counter then
        counter = 1
    end
    if counter > 5 then
        return {error = "too far down the rabbit hole"}
    end
    local tabChars = string.rep("\t",0)
    local result = "" .. tabChars .. "\n{\n"

    for key, value in pairs(obj) do
        result = result..tabChars.."\t".."key = "..tostring(key)
        if type(value) == "table" then
            result = result ..tabChars.."\t".."\n{\n"
            counter = counter + 1
            result = result .. tostring(dump(obj, counter))
            result = result ..tabChars.."\t".."\n}\n"
        else
            result = result..tabChars.."\t".." value = "..tostring(value).."\n"
        end
    end
    return result
end
