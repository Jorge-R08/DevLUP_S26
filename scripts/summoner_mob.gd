extends defaultMob

var last_turn_defend : bool = false
var first_heal : bool = false
var second_heal : bool = false

@export var player : Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func decide_action() -> Action:
	if curr_health <= max_health/3 and !first_heal:
		first_heal = true
		last_turn_defend = false
		return (actions["heal"])
	elif choose([true, true, false]) or last_turn_defend or player.stunned > 0:
		last_turn_defend = false
		return (actions["slash"])
	else:
		last_turn_defend = true
		return (actions["defend"])
