PERSPECTIVE_DEG_OFFSET=90

--[[
    for some reason or another
    there is a different perspective
    where 180 degrees isn't left, its up
--]]
function toRadian(deg)
    return math.rad(deg + 90);
end

function getOppAng(rad)
    return ((rad + 180) % 360)
end

-- todo fixme, this may be useless
function getOppAngDeg(deg)
    return (toRadian(deg) + 180) % 360
end
