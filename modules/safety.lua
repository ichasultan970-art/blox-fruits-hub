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
Safety.WHITELIST = {
    StartQuest = true, SetTeam = true, StoreFruit = true,
    getInventoryFruits = true, weaponChange = true, hit = true,
    requestEntrance = true,
}
function Safety.QueueNew()
    return { inflight = 0, pending = {} }
end
function Safety.QueuePush(q, verb, args)
    if q == nil then return false end
    if Safety.WHITELIST[verb] ~= true then return false end
    if q.inflight >= Safety.MAX_INFLIGHT then
        table.insert(q.pending, { verb = verb, args = args })
    else
        q.inflight = 1
    end
    return true
end
function Safety.QueueRelease(q)
    if q == nil then return nil end
    q.inflight = 0
    local nxt = table.remove(q.pending, 1)
    if nxt ~= nil then q.inflight = 1 end
    return nxt
end
return Safety
