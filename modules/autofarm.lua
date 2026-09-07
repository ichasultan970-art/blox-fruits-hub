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
return Farm
