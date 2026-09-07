local ESP = {}
ESP.MAX_DIST = 1500
ESP.MAX_LABELS = 60
function ESP.Allow(dist, count)
    if dist > ESP.MAX_DIST then return false end
    if count >= ESP.MAX_LABELS then return false end
    return true
end
return ESP
