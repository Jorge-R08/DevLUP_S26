extends defaultMob

var last_turn_heal : bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func decide_action() -> Action:
	if choose([true, true, false]) or last_turn_heal:
		last_turn_heal = false
		return (actions["slash"])
	else:
		last_turn_heal = true
		return (actions["heal"])
