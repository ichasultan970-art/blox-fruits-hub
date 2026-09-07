local Rand = {}
function Rand.Uniform(lo, hi)
    return lo + (hi - lo) * math.random()
end
function Rand.Jitter(base, amp)
    return base + (math.random() * 2 - 1) * amp
end
return Rand
