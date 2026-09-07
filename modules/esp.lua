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

-- LIVE ESP (aktif otomatis saat modul di-require di Delta; aman di-host via guard).
do
    local hasGame = (game ~= nil and type(game.GetService) == "function")
    if hasGame == true and getgenv ~= nil and Drawing ~= nil and getgenv().HubEspRunning ~= true then
        getgenv().HubEspRunning = true
        local pool = {}
        local function label(i)
            if pool[i] == nil then
                local t = Drawing.new("Text")
                t.Size = 14; t.Center = true; t.Outline = true
                t.Color = Color3.fromRGB(0, 255, 0)
                pool[i] = t
            end
            return pool[i]
        end
        local function parts(folder)
            local out = {}
            local f = game:GetService("Workspace"):FindFirstChild(folder)
            if f == nil then return out end
            for _, m in ipairs(f:GetChildren()) do
                if m:IsA("Model") then
                    local hum = m:FindFirstChildOfClass("Humanoid")
                    if hum == nil or hum.Health > 0 then
                        local hrp = m:FindFirstChild("HumanoidRootPart")
                        local pos = nil
                        if hrp ~= nil then
                            pos = hrp.Position
                        else
                            local ok, piv = pcall(function() return m:GetPivot() end)
                            if ok then pos = piv.Position end
                        end
                        if pos ~= nil then table.insert(out, { inst = m, pos = pos }) end
                    end
                end
            end
            return out
        end
        local acc = 0
        game:GetService("RunService").RenderStepped:Connect(function(dt)
            acc = acc + dt
            if acc < 0.2 then return end
            acc = 0
            local cam = game:GetService("Workspace").CurrentCamera
            if cam == nil then return end
            local camPos = cam.CFrame.Position
            local items = {}
            for _, grp in ipairs({parts("Enemies"), parts("ChestModels"), parts("NPCs")}) do
                for _, it in ipairs(grp) do
                    table.insert(items, { dist = (it.pos - camPos).Magnitude, inst = it.inst, pos = it.pos })
                end
            end
            local vis = ESP.RenderList(items, ESP.MAX_LABELS, ESP.MAX_DIST)
            for _, d in ipairs(pool) do d.Visible = false end
            for i, it in ipairs(vis) do
                local sp, onScreen = cam:WorldToViewportPoint(it.pos)
                local d = label(i)
                if onScreen then
                    d.Text = it.inst.Name .. " [" .. math.floor(it.dist) .. "m]"
                    d.Position = Vector2.new(sp.X, sp.Y)
                    d.Visible = true
                else
                    d.Visible = false
                end
            end
        end)
    end
end
return ESP
