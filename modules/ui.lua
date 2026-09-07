-- TODO(Task 9): LOADING/FARMING states + Shared {Queue, State, Deps} composition (scaffold covers SAFE/READY/UPDATE-PENDING only)
local UI = {}
function UI.State(depsOk, patchGap)
    if patchGap == true then return "UPDATE-PENDING" end
    if depsOk ~= true then return "SAFE" end
    return "READY"
end
function UI.StateEx(depsOk, patchGap, booting, active)
    if booting == true then return "LOADING" end
    if patchGap == true then return "UPDATE-PENDING" end
    if depsOk ~= true then return "SAFE" end
    if active ~= nil and active ~= "none" then return "FARMING" end
    return "READY"
end
return UI
