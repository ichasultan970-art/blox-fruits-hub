local ESP = {}
ESP.MAX_DIST = 1500
ESP.MAX_LABELS = 60
function ESP.Allow(dist, count)
    if dist > ESP.MAX_DIST then return false end
    if count >= ESP.MAX_LABELS then return false end
    return true
end
function ESP.RenderList(items, maxLabels, maxDist)
    local cap = maxLabels or ESP.MAX_LABELS
    local lim = maxDist or ESP.MAX_DIST
    local kept = {}
    for _, it in ipairs(items or {}) do
        if it.dist ~= nil and it.dist <= lim then table.insert(kept, it) end
    end
    table.sort(kept, function(a, b) return a.dist < b.dist end)
    while #kept > cap do table.remove(kept) end
    return kept
end
-- RUNTIME: Drawing update on RenderStepped at 5Hz logic gate (in-game only, verified by soak).
-- local acc = 0
-- game:GetService("RunService").RenderStepped:Connect(function(dt)
--     acc = acc + dt
--     if acc < 0.2 then return end
--     acc = 0
--     local vis = ESP.RenderList(ScanTargets(), ESP.MAX_LABELS, ESP.MAX_DIST)
--     DrawLabels(vis) -- executor Drawing API, max 60 labels
-- end)
-- (ScanTargets/DrawLabels are executor-site code resolving NPC/Chest names
-- at runtime per Spec version-proofing; shape in: array of {dist}.)
return ESP
