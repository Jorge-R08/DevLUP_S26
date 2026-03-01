extends Node2D

@export var player: CharacterBody2D
@export var enemy_attack: Node2D
@export var enemy: Node2D

var player_turn := false

func _ready() -> void:
	await get_tree().create_timer(3.0).timeout
	print("TURN MANAGER READY")
	print(player.can_move)
	
	enemy_attack.attack_finished.connect(_on_enemy_attack_finished)
	start_enemy_turn()

func start_enemy_turn() -> void:
	player_turn = false
	print("START ENEMY TURN")
	await get_tree().create_timer(3.0).timeout
	enemy_attack.start_attack_one()
	enemy.healed = false
	_hide_action_buttons()

func _on_enemy_attack_finished() -> void:
	player_turn = true
	print("SWITCH TO PLAYER")
	player.set_can_move(false)
	player.reset_position()
	_show_action_buttons()

func _hide_action_buttons() -> void:
	var ab = get_node("UI/action_buttons")
	ab.get_node("Button").hide() 

func _show_action_buttons() -> void:
	var ab = get_node("UI/action_buttons")
	ab.get_node("Button").show() 
	
func _on_button_pressed() -> void: 
	print("SLASHING") 
	print("enemy =", enemy) 
	if player_turn:
		_hide_action_buttons() 
		enemy.take_damage(35) 
		start_enemy_turn()
	
func _on_enemy_attack_started(chosen_attack: int) -> void:
	player.set_can_move(chosen_attack != 0)
