local Safety = {}
Safety.MAX_INFLIGHT = 1
function Safety.QueueDepth(q)
    if q.inflight >= Safety.MAX_INFLIGHT then return 1 + #q.pending end
    return #q.pending
end
local WEIGHTS = { teleport = 10, rate = 8, range = 6, airtime = 4 }
function Safety.SuspicionAdd(s, ev)
    return s + (WEIGHTS[ev] or 2)
end
function Safety.AfkDue(elapsed, idled)
    if idled == true then return true end
    return elapsed >= 1199
end
return Safety
