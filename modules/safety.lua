local Safety = {}
Safety.MAX_INFLIGHT = 1
function Safety.QueueDepth(q)
    if q == nil then return 0 end
    local inf = q.inflight or 0
    local pend = q.pending or {}
    if inf >= Safety.MAX_INFLIGHT then return 1 + #pend end
    return #pend
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
