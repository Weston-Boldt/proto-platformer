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

