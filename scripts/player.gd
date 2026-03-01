extends Node2D

@export var actions : Dictionary[String, Action]

@export var max_health : int = 100
@export var max_stamina : int = 50
var curr_health : int = max_health
var curr_stamina : int = max_stamina


@onready var _health_bar: TextureProgressBar = $health_bar
@onready var _stamina_bar: TextureProgressBar = $stamina_bar

@export var is_player : bool


#status effects
@export var curse_blinded : bool = false

var blocking : bool = false

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
	
func reduce_stamina(amnt : int):
	curr_stamina = max(0, curr_stamina-amnt)
	_stamina_bar.value = curr_stamina	


func _on_defend_toggle_blocking() -> void:
	blocking = !blocking
