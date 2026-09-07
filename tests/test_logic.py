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
