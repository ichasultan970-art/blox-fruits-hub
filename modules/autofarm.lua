local Farm = {}
function Farm.Next(state)
    if state.quest ~= true then return "quest" end
    if state.at_mob ~= true then return "travel" end
    return "attack"
end
function Farm.Tick(st, dt, engaged, delay)
    if st == nil then return "quest" end
    st.cooldown = (st.cooldown or 0) - (dt or 0)
    local want = Farm.Next(st)
    if want ~= "attack" then return want end
    if st.cooldown > 0 then return "wait" end
    if engaged ~= true then return "wait" end
    st.cooldown = delay or 0.4
    return "fire"
end
-- RUNTIME: Heartbeat connect (in-game only, 5-10Hz gate, verified by soak).
-- local acc = 0
-- game:GetService("RunService").Heartbeat:Connect(function(dt)
--     acc = acc + dt
--     if acc < 0.15 then return end
--     acc = 0
--     if Sea.ModeOk(Shared.State.mode, "farm") ~= true then return end
--     local action = Farm.Tick(Shared.State, 0.15, Combat.IsInRange(dist) and Combat.BringOk(n), Combat.AttackDelay())
--     if action == "fire" then Safety.QueuePush(Shared.Queue, "hit", {}) end
-- end)
-- Anti-AFK (single input reset, no loops) + suspicion decay hooks for the same loop:
-- local idleAt = os.clock()
-- game:GetService("Players").LocalPlayer.Idled:Connect(function()
--     game:GetService("VirtualUser"):ClickButton2(Vector2.new())
--     idleAt = os.clock()
-- end)
-- Shared.State.suspicion = math.max(0, Shared.State.suspicion - dt * 0.5)

-- LIVE FARM v1 (auto-kill musuh terdekat; aktif hanya jika getgenv().HubFarm == true).
-- Tanpa quest turn-in (nol remote = nol sinyal rate) + tanpa bring-mobs. Aman di-host via guard.
do
    local hasGame = (game ~= nil and type(game.GetService) == "function")
    if hasGame == true and getgenv ~= nil and getgenv().HubFarm == true and getgenv().HubFarmRunning ~= true then
        local Mods = getgenv().HubFarm_Mods
        if Mods == nil or Mods.combat == nil or Mods.teleport == nil or Mods.sea == nil then
            print("[Hub] farm butuh loader v1.6+ (modul silang tidak ada)")
        else
            getgenv().HubFarmRunning = true
            local Combat, Teleport, Sea = Mods.combat, Mods.teleport, Mods.sea
            local TS = game:GetService("RunService")
            local TweenSvc = game:GetService("TweenService")
            local Players = game:GetService("Players")
            local VU = game:GetService("VirtualUser")
            local LP = Players.LocalPlayer
            local FState = { quest = true, at_mob = false, cooldown = 0 }
            local Trav = { target = nil, tween = nil, legs = {}, li = 1, pauseUntil = 0, lastDist = nil }
            local lastSay, lastEquip, awayTicks = 0, 0, 0
            local function say(msg)
                print("[Farm] " .. msg)
                pcall(function()
                    game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
                        Text = "[Farm] " .. msg, Color = Color3.fromRGB(255, 200, 0),
                        Font = Enum.Font.Code, FontSize = Enum.FontSize.Size18,
                    })
                end)
            end
            local function charParts()
                local ch = LP.Character
                if ch == nil then return nil, nil, nil end
                local hum = ch:FindFirstChildOfClass("Humanoid")
                local hrp = ch:FindFirstChild("HumanoidRootPart")
                if hum == nil or hrp == nil or hum.Health <= 0 then return nil, nil, nil end
                return ch, hum, hrp
            end
            local function setCollide(ch, on)
                for _, p in ipairs(ch:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = on end
                end
            end
            local function nearestEnemy(myPos)
                local folder = game:GetService("Workspace"):FindFirstChild("Enemies")
                if folder == nil then return nil, nil end
                local best, bestD = nil, nil
                for _, m in ipairs(folder:GetChildren()) do
                    if m:IsA("Model") then
                        local hum = m:FindFirstChildOfClass("Humanoid")
                        local hrp = m:FindFirstChild("HumanoidRootPart")
                        if hum ~= nil and hum.Health > 0 and hrp ~= nil then
                            local d = (hrp.Position - myPos).Magnitude
                            if bestD == nil or d < bestD then best, bestD = m, d end
                        end
                    end
                end
                return best, bestD
            end
            local function stopTween()
                if Trav.tween ~= nil then pcall(function() Trav.tween:Cancel() end) Trav.tween = nil end
            end
            local acc = 0
            TS.Heartbeat:Connect(function(dt)
                acc = acc + dt
                if acc < 0.15 then return end
                acc = 0
                if Sea.ModeOk("farm", "farm") ~= true then return end
                local ch, hum, hrp = charParts()
                if ch == nil then stopTween() Trav.target = nil return end
                local now = os.clock()
                if now - lastEquip > 2 then
                    lastEquip = now
                    if ch:FindFirstChildOfClass("Tool") == nil then
                        local bp = LP:FindFirstChild("Backpack")
                        local tool = bp and bp:FindFirstChildOfClass("Tool")
                        if tool ~= nil then pcall(function() hum:EquipTool(tool) end) end
                    end
                end
                local target, dist = nearestEnemy(hrp.Position)
                if target == nil then stopTween() Trav.target = nil setCollide(ch, true) return end
                if Trav.target ~= target then
                    stopTween() Trav.target = target Trav.legs = {} Trav.li = 1 Trav.pauseUntil = 0 awayTicks = 0 Trav.lastDist = nil
                end
                local engaged = Combat.IsInRange(dist)
                FState.at_mob = engaged
                if engaged then
                    stopTween() setCollide(ch, true) awayTicks = 0
                    local action = Farm.Tick(FState, 0.15, true, Combat.AttackDelay())
                    if action == "fire" then
                        VU:Button1Down(Vector2.new(100, 100))
                        task.wait(Combat.ClickDelay())
                        VU:Button1Up(Vector2.new(100, 100))
                    end
                else
                    if Trav.lastDist ~= nil and dist > Trav.lastDist then awayTicks = awayTicks + 1 else awayTicks = 0 end
                    Trav.lastDist = dist
                    if awayTicks > 20 then
                        stopTween() Trav.legs = {} Trav.li = 1 Trav.pauseUntil = now + 2 awayTicks = 0
                        say("diduga rubberband, jeda 2 dtk")
                        return
                    end
                    setCollide(ch, false)
                    if now >= Trav.pauseUntil and Trav.tween == nil then
                        if Trav.li > #Trav.legs then
                            Trav.legs = Teleport.PlanLegs(dist, 80)
                            Trav.li = 1
                        end
                        local eHrp = target:FindFirstChild("HumanoidRootPart")
                        if eHrp == nil then Trav.target = nil return end
                        local epos = eHrp.Position
                        local goal = CFrame.lookAt(epos + Vector3.new(0, 7, 0), epos)
                        local dur = Teleport.LegDuration((goal.Position - hrp.Position).Magnitude, 200)
                        local tw = TweenSvc:Create(hrp, TweenInfo.new(dur, Enum.EasingStyle.Linear), { CFrame = goal })
                        Trav.tween = tw
                        tw.Completed:Connect(function()
                            Trav.tween = nil Trav.li = Trav.li + 1
                            Trav.pauseUntil = os.clock() + Teleport.BetweenLegsPause()
                        end)
                        tw:Play()
                    end
                end
                if now - lastSay > 10 then
                    lastSay = now
                    say("target=" .. target.Name .. " jarak=" .. math.floor(dist) .. "m cd=" .. string.format("%.2f", FState.cooldown))
                end
            end)
            say("farm v1 aktif: auto-kill musuh terdekat, tanpa quest, tanpa bring.")
        end
    end
end
return Farm
