local Combat = {}
Combat.ATTACK_MIN = 0.3
Combat.ATTACK_MAX = 0.5
Combat.REACH = 7
Combat.BRING_MAX = 5
function Combat.AttackDelayMid() return 0.4 end
function Combat.IsInRange(d) return d <= Combat.REACH end
function Combat.BringOk(n) return n <= Combat.BRING_MAX end
return Combat
