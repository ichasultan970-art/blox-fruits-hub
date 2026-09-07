local Loader = {}
Loader.VERSION = "1.2.0"
function Loader.DepsOk(deps)
    if deps == nil then return false end
    if deps.CommF_ ~= true then return false end
    if deps.Quests ~= true then return false end
    return true
end
function Loader.BuildDeps(hasCommF, hasQuests)
    return { CommF_ = (hasCommF == true), Quests = (hasQuests == true) }
end

-- ACTIVE BOOT (jalan saat di-loadstring di Delta; aman di-host karena terjaga guard).
do
    local hasGame = (game ~= nil and type(game.GetService) == "function")
    if hasGame ~= true then return Loader end
    local exName = tostring((getexecutorname and getexecutorname()) or "unknown")
    print("[Hub] boot v" .. Loader.VERSION .. " executor: " .. exName)
    local REPO = "https://raw.githubusercontent.com/ichasultan970-art/blox-fruits-hub/main/"
    local _hui = ((gethui and gethui()) or game:GetService("CoreGui"))
    local root = Instance.new("Folder"); root.Name = "Hub"; root.Parent = _hui
    local names = {"rand","combat","teleport","safety","shared","autofarm","esp","sea_raid","ui"}
    local fails = {}
    for _, name in ipairs(names) do
        local okSrc, src = pcall(game.HttpGet, game, REPO .. "modules/" .. name .. ".lua")
        if okSrc ~= true then
            warn("[Hub] gagal unduh modul " .. name)
            table.insert(fails, name)
        else
            local m = Instance.new("ModuleScript"); m.Name = name; m.Source = src; m.Parent = root
        end
    end
    local Hub = {}
    for _, name in ipairs(names) do
        local child = root:FindFirstChild(name)
        if child == nil then
            table.insert(fails, name .. "(hilang)")
        else
            local ok, mod = pcall(require, child)
            if ok ~= true then table.insert(fails, name .. "(require)") else Hub[name] = mod end
        end
    end
    local Remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    local commOk = false
    if Remotes ~= nil then
        local ok, comm = pcall(function() return Remotes:WaitForChild("CommF_", 5) end)
        commOk = (ok == true and comm ~= nil)
    end
    local quests = game:GetService("Workspace"):FindFirstChild("Quests")
    local deps = Loader.BuildDeps(commOk, quests ~= nil)
    local status
    if Loader.DepsOk(deps) ~= true then
        status = "SAFE (farm mati, ESP saja)"
    else
        status = "READY (semua dep hijau)"
    end
    local lines = {
        "[Hub] v" .. Loader.VERSION .. " | " .. exName,
        "modul gagal: " .. (#fails == 0 and "-" or table.concat(fails, ",")),
        "CommF_=" .. tostring(deps.CommF_) .. " Quests=" .. tostring(deps.Quests),
        "status: " .. status,
        "anti-AFK: aktif",
    }
    for _, ln in ipairs(lines) do print(ln) end
    -- Overlay di layar game (tidak butuh console Delta):
    pcall(function()
        local pg = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui", 5)
        local gui = Instance.new("ScreenGui"); gui.Name = "HubStatus"; gui.ResetOnSpawn = false
        local box = Instance.new("TextLabel")
        box.Size = UDim2.new(0, 300, 0, 110)
        box.Position = UDim2.new(0.5, -150, 0, 10)
        box.BackgroundTransparency = 0.3
        box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        box.TextColor3 = Color3.fromRGB(0, 255, 0)
        box.TextSize = 14
        box.Font = Enum.Font.Code
        box.Text = table.concat(lines, "\n")
        box.Parent = gui; gui.Parent = pg
    end)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Hub " .. status,
            Text = "Boot v" .. Loader.VERSION .. " selesai",
            Duration = 5,
        })
    end)
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end)
end
return Loader
