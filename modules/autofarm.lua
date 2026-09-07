local Farm = {}
function Farm.Next(state)
    if state.quest ~= true then return "quest" end
    if state.at_mob ~= true then return "travel" end
    return "attack"
end
return Farm
