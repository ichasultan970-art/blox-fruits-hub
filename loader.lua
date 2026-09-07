local Loader = {}
function Loader.DepsOk(deps)
    if deps == nil then return false end
    if deps.CommF_ ~= true then return false end
    if deps.Quests ~= true then return false end
    return true
end
function Loader.BuildDeps(hasCommF, hasQuests)
    return { CommF_ = (hasCommF == true), Quests = (hasQuests == true) }
end
-- RUNTIME: Delta boot sequence (in-game only, verified by soak).
-- local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 5)
-- local ok, comm = pcall(function() return Remotes:WaitForChild("CommF_", 5) end)
-- local quests = game:GetService("Workspace"):FindFirstChild("Quests")
-- Shared.Deps = Loader.BuildDeps(ok and comm ~= nil, quests ~= nil)
-- if Loader.DepsOk(Shared.Deps) ~= true then UI.State(false, false) end -- SAFE, ESP only
-- Module tree so `require(script.Parent.rand)` (Tasks 1-2) resolves in-game:
-- local REPO = "https://raw.githubusercontent.com/<user>/blox-fruits-hub/main/"
-- local root = Instance.new("Folder"); root.Name = "Hub"; root.Parent = gethui()
-- for _, name in ipairs({"rand","combat","teleport","safety","shared","autofarm","esp","sea_raid","ui"}) do
--     local m = Instance.new("ModuleScript"); m.Name = name
--     m.Source = game:HttpGet(REPO .. "modules/" .. name .. ".lua"); m.Parent = root
-- end
return Loader
