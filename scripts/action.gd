class_name Action
extends Node

const STAMINA_GAIN_ON_SKIP = 15
const STAMINA_GAIN_ON_ACTION = 5
const TURN_WAIT_RESET = 1

enum action_type {
	ATTACK,
	HEAL,
	SPECIAL,
	BLOCK,
	SKIP
}

@export var display_name : String
@export var description : String

@export var type : action_type
@export var damage : int
@export var heal_amnt : int = 0
@export var cost : int
@export var recoil : int = 0
@export var turn_wait : int = TURN_WAIT_RESET

@onready var action_label: TextureRect

signal toggle_blocking
signal mob_attack(action_name : String)

var curr_turn_wait : int = TURN_WAIT_RESET
var label_timer : SceneTreeTimer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	action_label = get_parent().get_parent().find_child("action_label")
	print(action_label)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func trigger(target : Node2D):
	var char : Node2D = get_parent().get_parent()

	if char.name == "Player":
		char.reduce_stamina(cost)
		char.increase_stamina(STAMINA_GAIN_ON_ACTION)
		curr_turn_wait = TURN_WAIT_RESET-1
	elif char.name == "mob":
		print("char name is MOBBBBBBBBBBBBBBB")
		mob_attack.emit(display_name)
	
	match type:
		action_type.ATTACK:
			char.animation_player.play("attack")
			print("ATTACK ACTION PERFORMED")
			if char.curse_blinded and !choose([true, true, true, false, false]):
				print("ATTACK MISSSED")
			else:
				target.take_damage(damage)
			if char.name == "Player" and display_name == "biden_blast":
				char.stunned = 1
			if char.name == "Player" and display_name == "pharaohs_curse":
				target.curse_blinded = 4
		action_type.HEAL:
			print("HEAL ACTION PERFORMED")
			char.heal(heal_amnt)
		action_type.SPECIAL:
			print("SPECIAL ACTION PERFORMED")
		action_type.BLOCK:
			print("BLOCK ACTION PERFORMED")
		action_type.SKIP:
			print("SKIP ACTION PERFORMED")
			char.increase_stamina(STAMINA_GAIN_ON_SKIP)

func choose(array : Array):
	array.shuffle()
	return array[0]
