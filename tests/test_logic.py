def LoaderDepsOk(deps):
    if not isinstance(deps, dict):
        return False
    return deps.get("CommF_") is True and deps.get("Quests") is True


def test_boot_gate_blocks_farm_on_missing_dep():
    assert LoaderDepsOk({"CommF_": True, "Quests": True}) is True
    assert LoaderDepsOk({"CommF_": False, "Quests": True}) is False
