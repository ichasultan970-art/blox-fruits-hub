local Teleport = {}
Teleport.DEFAULT_SPEED = 200
Teleport.MAX_SPEED = 250
Teleport.SINGLE_JUMP_MAX = 80
-- TODO(Task 9): enforce per-leg <= SINGLE_JUMP_MAX in tween executor with pause
function Teleport.ClampSpeed(s)
    if s == nil or s <= 0 then return Teleport.DEFAULT_SPEED end
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
