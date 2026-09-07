local Loader = {}
Loader.VERSION = "1.3.0"
function Loader.DepsOk(deps)
    if deps == nil then return false end
    if deps.CommF_ ~= true then return false end
    if deps.Quests ~= true then return false end
    return true
end
function Loader.BuildDeps(hasCommF, hasQuests)
    return { CommF_ = (hasCommF == true), Quests = (hasQuests == true) }
end

-- ACTIVE BOOT v1.3: tanpa Instance.new (diblokir di konteks Delta ini).
-- Modul dimuat via loadstring + env, require di-shim ke tabel modul.
do
    local hasGame = (game ~= nil and type(game.GetService) == "function")
    if hasGame ~= true then return Loader end
    local exName = tostring((getexecutorname and getexecutorname()) or "unknown")
    local function say(msg)
        print("[Hub] " .. msg)
        pcall(function()
            game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
                Text = "[Hub] " .. msg,
                Color = Color3.fromRGB(0, 255, 0),
                Font = Enum.Font.Code,
                FontSize = Enum.FontSize.Size18,
            })
        end)
    end
    say("boot v" .. Loader.VERSION .. " executor: " .. exName)
    local REPO = "https://raw.githubusercontent.com/ichasultan970-art/blox-fruits-hub/main/"
    local names = {"rand","combat","teleport","safety","shared","autofarm","esp","sea_raid","ui"}
    local srcs, fails = {}, {}
    for _, name in ipairs(names) do
        local okSrc, src = pcall(game.HttpGet, game, REPO .. "modules/" .. name .. ".lua")
        if okSrc ~= true then
            table.insert(fails, name)
        else
            srcs[name] = src
        end
    end
    local Hub, RAND_TOKEN = {}, {}
    local function runmod(src, name, extra)
        local fn, err = loadstring(src, "=" .. name)
        if fn == nil then return nil, err end
        setfenv(fn, setmetatable(extra or {}, {__index = getgenv()}))
        local ok, res = pcall(fn)
        if ok ~= true then return nil, res end
        return res
    end
    local fakeScript = { Parent = { rand = RAND_TOKEN } }
    local function fakeRequire(x)
        if x == RAND_TOKEN then return Hub.rand end
        return require(x)
    end
    for _, name in ipairs(names) do
        local src = srcs[name]
        if src == nil then
            table.insert(fails, name .. "(unduh)")
        else
            local extra = nil
            if name == "combat" or name == "teleport" then
                extra = { script = fakeScript, require = fakeRequire }
            end
            local mod, err = runmod(src, name, extra)
            if mod == nil then
                table.insert(fails, name .. "(load)")
                say("gagal muat " .. name .. ": " .. tostring(err):sub(1, 120))
            else
                Hub[name] = mod
            end
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
    say("modul gagal: " .. (#fails == 0 and "-" or table.concat(fails, ",")))
    say("CommF_=" .. tostring(deps.CommF_) .. " Quests=" .. tostring(deps.Quests))
    if Loader.DepsOk(deps) ~= true then
        say("status: SAFE (farm mati, ESP saja)")
    else
        say("status: READY (semua dep hijau)")
    end
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Hub boot v" .. Loader.VERSION,
            Text = "Selesai, cek chat sistem",
            Duration = 5,
        })
    end)
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end)
    say("anti-AFK aktif. Boot selesai.")
end
return Loader
