PERSPECTIVE_DEG_OFFSET=90

--[[
some weirdness here:
    math.pi         (180 deg) == directly up 
    0     (360 deg) (0 deg)   == directly down
    math.pi / 2     (90 deg)  == directly right
    3 * math.pi / 2 (270 deg) == directly left
--]]

--[[
    for some reason or another
    there is a different perspective
    where 180 degrees isn't left, its up
--]]
function toRadian(deg)
    return math.rad(deg + 90);
end

function getOppAng(deg)
    return (deg + 180) % 360
end

-- todo fixme, this may be useless
function getOppAngDeg(deg)
    return (toRadian(deg) + 180) % 360
end
