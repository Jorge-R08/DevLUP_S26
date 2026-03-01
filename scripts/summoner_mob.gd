extends defaultMob

var first_heal : bool = false
var second_heal : bool = false
var pharaohs_cooldown : int = 2

signal summoner_dead

@export var player : Node2D


func take_damage(dmg : int):
	curr_health = max(0, curr_health-dmg)
	_health_bar.value = curr_health
	if curr_health > 0:
		animation_player.play("hurt")
	else:
		animation_player.play("summon")
		summoner_dead.emit()

func decide_action() -> Action:
	if curr_health <= max_health/3 and !first_heal:
		first_heal = true
		pharaohs_cooldown += 1
		return (actions["heal"])
	elif choose([true, true, true, true, false]) or player.stunned > 0:
		if choose([true, true, false]) and pharaohs_cooldown < 2:
			pharaohs_cooldown += 1
			return (actions["slash"])
		else:
			pharaohs_cooldown = 0
			print("THE PHARAOHS CURSE")
			return (actions["pharaohs_curse"])
	else:
		pharaohs_cooldown += 1
		return (actions["heal"])
