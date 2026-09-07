local Loader = {}
function Loader.DepsOk(deps)
    if deps == nil then return false end
    if deps.CommF_ ~= true then return false end
    if deps.Quests ~= true then return false end
    return true
end
return Loader
