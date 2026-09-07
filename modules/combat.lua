local Combat = {}
Combat.ATTACK_MIN = 0.3
Combat.ATTACK_MAX = 0.5
Combat.REACH = 7
Combat.BRING_MAX = 5
function Combat.IsInRange(d) return d <= Combat.REACH end
function Combat.BringOk(n) return n <= Combat.BRING_MAX end
local Rand = require(script.Parent.rand)
function Combat.AttackDelay() return Rand.Uniform(Combat.ATTACK_MIN, Combat.ATTACK_MAX) end
function Combat.ClickDelay()
    return math.max(0.05, Rand.Jitter(Rand.Uniform(0.12, 0.18), 0.03))
end
return Combat
