extends Node2D

@export var player: CharacterBody2D
@export var enemy_attack: Node2D

func _ready() -> void:
	await get_tree().create_timer(3.0).timeout
	print("TURN MANAGER READY")
	enemy_attack.attack_finished.connect(_on_enemy_attack_finished)
	start_enemy_turn()

func start_enemy_turn() -> void:
	print("START ENEMY TURN")
	player.set_can_move(true)
	enemy_attack.start_attack_one()

func _on_enemy_attack_finished() -> void:
	print("SWITCH TO PLAYER")
	await get_tree().create_timer(5.0).timeout
	player.set_can_move(false)
	player.reset_position()
