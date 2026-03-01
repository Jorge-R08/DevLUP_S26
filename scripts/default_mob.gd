extends Node2D

@export var actions : Dictionary[String, Action]
@export var max_health : int = 100
var curr_health : int = max_health


@onready var _health_bar: TextureProgressBar = $health_bar

@export var is_player : bool
@export var curse_blinded : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func start_turn():
	if !is_player:
		print("Mob turn start")
	else:
		print("Player turn start")

	
func end_turn():
	if !is_player:
		print("Mob turn end")
	else:
		print("Player turn end")
	
func take_damage(dmg : int):
	#hurt animation
	curr_health = max(0, curr_health-dmg)
	_health_bar.value = curr_health
	
func heal(amnt : int):
	#heal animation
	curr_health = min(max_health, curr_health+amnt)
	_health_bar.value = curr_health
