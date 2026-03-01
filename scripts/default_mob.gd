class_name defaultMob
extends Node2D

@export var actions : Dictionary[String, Action]
@export var max_health : int
var curr_health : int = max_health
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const CURSE_BLIND_TURNS = 4

var blocking : bool = false
signal mob_dead

@onready var _health_bar: TextureProgressBar = $health_bar
@onready var label_timer: Timer = $action_label/label_timer
@onready var action_label: TextureRect = $action_label

@export var is_player : bool
@export var curse_blinded : bool = false
var curr_curse_blind_turns = 0

#signal mob_action(action : Action)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	curr_health=max_health
	for action in actions:
		actions[action].mob_attack.connect(on_mob_attack)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func on_mob_attack(action_name : String):
	print("on mob attack")
	action_label.find_child("RichTextLabel").text = action_name
	action_label.visible = true #maybe add a twink
	label_timer.start()
	
func start_turn():
	print("Mob turn start -- MOB HEALTH: ", curr_health)
	

func end_turn():
	print("Mob turn end")
	
func take_damage(dmg : int):
	if blocking: dmg = dmg / 2
	curr_health = max(0, curr_health-dmg)
	_health_bar.value = curr_health
	if curr_health > 0:
		animation_player.play("hurt")
	else:
		animated_sprite_2d.play("die")
		mob_dead.emit()
	
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

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "die":
		queue_free()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if animation_player.assigned_animation == "summon":
		animated_sprite_2d.play("die")


func _on_defend_toggle_blocking(to_player: bool) -> void:
	if !to_player:
		blocking = true
