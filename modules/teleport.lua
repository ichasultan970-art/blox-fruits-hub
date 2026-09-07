local Teleport = {}
Teleport.DEFAULT_SPEED = 200
Teleport.MAX_SPEED = 250
Teleport.SINGLE_JUMP_MAX = 80
function Teleport.ClampSpeed(s)
    if s > Teleport.MAX_SPEED then return Teleport.MAX_SPEED end
    return s
end
function Teleport.TweenDuration(dist, speed)
    return dist / Teleport.ClampSpeed(speed)
end
function Teleport.SplitLegs(dist)
    if dist > 1500 then return 3 end
    return 1
end
return Teleport
