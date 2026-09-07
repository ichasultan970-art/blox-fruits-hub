local UI = {}
function UI.State(depsOk, patchGap)
    if patchGap == true then return "UPDATE-PENDING" end
    if depsOk ~= true then return "SAFE" end
    return "READY"
end
return UI
