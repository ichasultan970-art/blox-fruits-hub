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
local Rand = require(script.Parent.rand)
function Teleport.PlanLegs(dist, maxLeg)
    local cap = maxLeg or Teleport.SINGLE_JUMP_MAX
    if dist <= 0 then return {} end
    local n = math.max(1, math.ceil(dist / cap))
    local legs = {}
    for i = 1, n do legs[i] = dist / n end
    return legs
end
function Teleport.LegDuration(len, speed)
    return len / Teleport.ClampSpeed(Rand.Jitter(speed or Teleport.DEFAULT_SPEED, 10))
end
function Teleport.BetweenLegsPause()
    return Rand.Uniform(0.3, 0.8)
end
return Teleport
