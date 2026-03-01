class_name defaultMob
extends Node2D

@export var actions : Dictionary[String, Action]
@export var max_health : int = 100
var curr_health : int = max_health
@onready var animation_player: AnimationPlayer = $AnimationPlayer


@onready var _health_bar: TextureProgressBar = $health_bar
@onready var label_timer: Timer = $action_label/label_timer
@onready var action_label: TextureRect = $action_label

@export var is_player : bool
@export var curse_blinded : bool = false

#signal mob_action(action : Action)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for action in actions:
		actions[action].mob_attack.connect(on_mob_attack)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func on_mob_attack(action_name : String):
	action_label.find_child("RichTextLabel").text = action_name
	action_label.visible = true #maybe add a twink
	label_timer.start()
	
func start_turn():
	print("Mob turn start")

func end_turn():
	print("Mob turn end")
	
func take_damage(dmg : int):
	#hurt animation
	curr_health = max(0, curr_health-dmg)
	_health_bar.value = curr_health
	animation_player.play("hurt")
	
func heal(amnt : int):
	#heal animation
	curr_health = min(max_health, curr_health+amnt)
	_health_bar.value = curr_health

func _on_label_timer_timeout() -> void:
	action_label.visible = false
	
func decide_action():
	print("PERFORM ACTION NOT OVERWRITEEN")
	
func choose(array : Array):
	array.shuffle()
	return array[0]
