def LoaderDepsOk(deps):
    if not isinstance(deps, dict):
        return False
    return deps.get("CommF_") is True and deps.get("Quests") is True


def test_boot_gate_blocks_farm_on_missing_dep():
    assert LoaderDepsOk({"CommF_": True, "Quests": True}) is True
    assert LoaderDepsOk({"CommF_": False, "Quests": True}) is False


def test_queue_single_flight():
    assert QueueDepth({"inflight": 0, "pending": [1,2,3]}) == 3
    assert QueueDepth({"inflight": 0, "pending": []}) == 0
    assert QueueDepth({"inflight": 0, "pending": [1, 2]}) == 2
    assert QueueDepth({"inflight": 1, "pending": [1, 2]}) == 3
    assert SuspicionAdd(0, "teleport") == 10
    assert AfkDue(1199, False) is True
    assert AfkDue(60, False) is False


def QueueDepth(q):
    pending = q.get("pending", [])
    if q.get("inflight", 0) >= 1:
        return 1 + len(pending)
    return len(pending)

def SuspicionAdd(s, ev):
    return s + {"teleport": 10, "rate": 8, "range": 6, "airtime": 4}.get(ev, 2)

def AfkDue(elapsed, idled):
    if idled is True:
        return True
    return elapsed >= 1199


def test_tween_caps():
    assert TweenDuration(400, 200) == 2.0
    assert TweenDuration(400, 500) == 1.6
    assert SplitLegs(1600) == 3
    assert SplitLegs(500) == 1


def _clamp_speed(s):
    if s is None or s <= 0:
        return 200
    return 250 if s > 250 else s

def TweenDuration(dist, speed):
    return dist / _clamp_speed(speed)

def SplitLegs(dist):
    return 3 if dist > 1500 else 1


def test_combat_pacing_bounds():
    d = AttackDelayMid()
    assert 0.3 <= d <= 0.5
    assert IsInRange(6.5) is True
    assert IsInRange(30) is False
    assert BringOk(4) is True
    assert BringOk(8) is False


def AttackDelayMid():
    return 0.4

def IsInRange(d):
    return d <= 7

def BringOk(n):
    return n <= 5


def test_farm_never_skips_quest():
    assert FarmNext({"quest": False, "at_mob": False}) == "quest"
    assert FarmNext({"quest": True, "at_mob": False}) == "travel"
    assert FarmNext({"quest": True, "at_mob": True}) == "attack"


def FarmNext(state):
    if state.get("quest") is not True:
        return "quest"
    if state.get("at_mob") is not True:
        return "travel"
    return "attack"


def test_esp_caps_labels():
    assert EspAllow(500, 10) is True
    assert EspAllow(5000, 10) is False
    assert EspAllow(500, 200) is False


def EspAllow(dist, count):
    if dist > 1500:
        return False
    if count >= 60:
        return False
    return True


def test_single_mode_lock():
    assert ModeOk("farm", "raid") is False
    assert ModeOk("none", "raid") is True
    assert ShouldHop(True, False, 0) is True
    assert ShouldHop(False, False, 0) is False


def ModeOk(active, want):
    if active == "none":
        return True
    return active == want

def ShouldHop(empty, contested, timeouts):
    if empty is True:
        return True
    if contested is True:
        return True
    if timeouts >= 3:
        return True
    return False


def test_safe_fallback():
    assert UiState(True, False) == "READY"
    assert UiState(False, False) == "SAFE"
    assert UiState(True, True) == "UPDATE-PENDING"


def UiState(depsOk, patchGap):
    if patchGap is True:
        return "UPDATE-PENDING"
    if depsOk is not True:
        return "SAFE"
    return "READY"


def test_pacing_is_randomized():
    ds = [AttackDelay() for _ in range(50)]
    assert all(0.3 <= d <= 0.5 for d in ds)
    assert max(ds) - min(ds) > 0.05
    cs = [ClickDelay() for _ in range(50)]
    assert all(0.05 <= c <= 0.21 for c in cs)
    assert max(cs) - min(cs) > 0.02


import random

def Uniform(lo, hi):
    return lo + (hi - lo) * random.random()

def Jitter(base, amp):
    return base + (random.random() * 2 - 1) * amp

def AttackDelay():
    return Uniform(0.3, 0.5)

def ClickDelay():
    return max(0.05, Jitter(Uniform(0.12, 0.18), 0.03))


import math

def PlanLegs(dist, maxLeg=80):
    if dist <= 0:
        return []
    n = max(1, math.ceil(dist / maxLeg))
    return [dist / n for _ in range(n)]

def LegDuration(length, speed):
    return length / _clamp_speed(Jitter(speed or 200, 10))

def BetweenLegsPause():
    return Uniform(0.3, 0.8)


def test_leg_plan_clamps_jumps():
    legs = PlanLegs(1600, 80)
    assert len(legs) == 20
    assert all(l <= 80 for l in legs)
    assert abs(sum(legs) - 1600) < 1e-6
    assert PlanLegs(50, 80) == [50]
    assert 0.3 <= BetweenLegsPause() <= 0.8
    assert LegDuration(80, 200) > 0


def test_queue_whitelist():
    q = QueueNew()
    assert QueuePush(q, "StartQuest", {"a": 1}) is True
    assert QueuePush(q, "DeleteAllData", {}) is False
    assert QueuePush(q, "hit", {}) is True
    assert len(q["pending"]) == 1
    nxt = QueueRelease(q)
    assert nxt == {"verb": "hit", "args": {}}


WHITELIST = {"StartQuest", "SetTeam", "StoreFruit", "getInventoryFruits", "weaponChange", "hit", "requestEntrance"}

def QueueNew():
    return {"inflight": 0, "pending": []}

def QueuePush(q, verb, args):
    if q is None:
        return False
    if verb not in WHITELIST:
        return False
    if q["inflight"] >= 1:
        q["pending"].append({"verb": verb, "args": args})
    else:
        q["inflight"] = 1
    return True

def QueueRelease(q):
    if q is None:
        return None
    q["inflight"] = 0
    if q["pending"]:
        q["inflight"] = 1
        return q["pending"].pop(0)
    return None


def test_shared_shape():
    s = SharedNew()
    assert s["Queue"] == {"inflight": 0, "pending": []}
    assert s["State"]["mode"] == "none"
    assert s["State"]["cooldown"] == 0
    assert BuildDeps(True, True) == {"CommF_": True, "Quests": True}
    assert BuildDeps(False, True)["CommF_"] is False


def SharedNew():
    return {
        "Queue": {"inflight": 0, "pending": []},
        "State": {"mode": "none", "quest": False, "at_mob": False, "cooldown": 0, "suspicion": 0},
        "Deps": {},
    }

def BuildDeps(hasCommF, hasQuests):
    return {"CommF_": hasCommF is True, "Quests": hasQuests is True}


def test_farm_tick_fires_once_per_cooldown():
    st = {"quest": True, "at_mob": True, "cooldown": 0}
    assert FarmTick(st, 0.1, True, 0.4) == "fire"
    assert FarmTick(st, 0.1, True, 0.4) == "wait"
    assert FarmTick(st, 0.5, True, 0.4) == "fire"
    assert FarmTick({"quest": False, "at_mob": False, "cooldown": 0}, 0.1, True, 0.4) == "quest"
    assert FarmTick(None, 0.1, True, 0.4) == "quest"


def FarmTick(st, dt, engaged, delay):
    if st is None:
        return "quest"
    st["cooldown"] = st.get("cooldown", 0) - (dt or 0)
    want = FarmNext(st)
    if want != "attack":
        return want
    if st["cooldown"] > 0:
        return "wait"
    if engaged is not True:
        return "wait"
    st["cooldown"] = delay if delay is not None else 0.4
    return "fire"


def test_render_and_ui_states():
    items = [{"dist": 5000}, {"dist": 100}, {"dist": 900}]
    out = RenderList(items, 60, 1500)
    assert [i["dist"] for i in out] == [100, 900]
    assert len(RenderList([{"dist": 10}] * 200, 60, 1500)) == 60
    assert UiStateEx(True, False, True, "none") == "LOADING"
    assert UiStateEx(True, True, False, "farm") == "UPDATE-PENDING"
    assert UiStateEx(False, False, False, "none") == "SAFE"
    assert UiStateEx(True, False, False, "farm") == "FARMING"
    assert UiStateEx(True, False, False, "none") == "READY"


def RenderList(items, maxLabels=60, maxDist=1500):
    cap = maxLabels if maxLabels is not None else 60
    lim = maxDist if maxDist is not None else 1500
    kept = [it for it in (items or []) if it.get("dist") is not None and it["dist"] <= lim]
    kept.sort(key=lambda it: it["dist"])
    return kept[:cap]

def UiStateEx(depsOk, patchGap, booting, active):
    if booting is True:
        return "LOADING"
    if patchGap is True:
        return "UPDATE-PENDING"
    if depsOk is not True:
        return "SAFE"
    if active is not None and active != "none":
        return "FARMING"
    return "READY"
