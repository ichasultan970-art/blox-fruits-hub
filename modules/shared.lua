local Shared = {}
function Shared.New()
    return {
        Queue = { inflight = 0, pending = {} },
        State = { mode = "none", quest = false, at_mob = false, cooldown = 0, suspicion = 0 },
        Deps = {},
    }
end
return Shared
