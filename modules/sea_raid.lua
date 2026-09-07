local Sea = {}
function Sea.ModeOk(active, want)
    if active == "none" then return true end
    return active == want
end
function Sea.ShouldHop(empty, contested, timeouts)
    if empty == true then return true end
    if contested == true then return true end
    if timeouts >= 3 then return true end
    return false
end
return Sea
