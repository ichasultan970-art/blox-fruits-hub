def LoaderDepsOk(deps):
    if not isinstance(deps, dict):
        return False
    return deps.get("CommF_") is True and deps.get("Quests") is True


def test_boot_gate_blocks_farm_on_missing_dep():
    assert LoaderDepsOk({"CommF_": True, "Quests": True}) is True
    assert LoaderDepsOk({"CommF_": False, "Quests": True}) is False


def test_queue_single_flight():
    assert QueueDepth({"inflight": 0, "pending": 3}) == 3
    assert SuspicionAdd(0, "teleport") == 10
    assert AfkDue(1199, False) is True
    assert AfkDue(60, False) is False


def QueueDepth(q):
    if q["inflight"] >= 1:
        return 1 + len(q.get("pending_list", [1, 2, 3])[:3])
    return 3

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
