local Loader = {}
Loader.VERSION = "1.1.0"
function Loader.DepsOk(deps)
    if deps == nil then return false end
    if deps.CommF_ ~= true then return false end
    if deps.Quests ~= true then return false end
    return true
end
function Loader.BuildDeps(hasCommF, hasQuests)
    return { CommF_ = (hasCommF == true), Quests = (hasQuests == true) }
end

-- ACTIVE BOOT (jalan saat di-loadstring di Delta; aman di-host karena terjaga pcall + guard).
do
    local hasGame = (typeof and typeof(game) == "Instance") or (game ~= nil and type(game.GetService) == "function")
    if hasGame ~= true then return Loader end
    print("[Hub] boot v" .. Loader.VERSION .. " executor: " .. tostring((getexecutorname and getexecutorname()) or "unknown"))
    local REPO = "https://raw.githubusercontent.com/ichasultan970-art/blox-fruits-hub/main/"
    local _hui = ((gethui and gethui()) or game:GetService("CoreGui"))
    local root = Instance.new("Folder"); root.Name = "Hub"; root.Parent = _hui
    local names = {"rand","combat","teleport","safety","shared","autofarm","esp","sea_raid","ui"}
    for _, name in ipairs(names) do
        local okSrc, src = pcall(game.HttpGet, game, REPO .. "modules/" .. name .. ".lua")
        if okSrc ~= true then
            warn("[Hub] gagal unduh modul " .. name)
        else
            local m = Instance.new("ModuleScript"); m.Name = name; m.Source = src; m.Parent = root
        end
    end
    local Hub = {}
    for _, name in ipairs(names) do
        local child = root:FindFirstChild(name)
        if child == nil then
            warn("[Hub] modul hilang: " .. name)
        else
            local ok, mod = pcall(require, child)
            if ok ~= true then warn("[Hub] gagal require " .. name) else Hub[name] = mod end
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
    print("[Hub] deps CommF_=" .. tostring(deps.CommF_) .. " Quests=" .. tostring(deps.Quests))
    local uiState = Hub.ui and Hub.ui.StateEx(true, false, false, "none") or "UNKNOWN"
    if Loader.DepsOk(deps) ~= true then
        print("[Hub] status: SAFE (farm mati, ESP saja). Alasan: dep belum hijau.")
    else
        print("[Hub] status: READY (semua dep hijau). UI state: " .. tostring(uiState))
    end
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end)
    print("[Hub] anti-AFK aktif. Boot selesai.")
end
return Loader
