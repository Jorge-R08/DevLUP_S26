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
@export var turn_wait : int = TURN_WAIT_RESET

signal toggle_blocking

var curr_turn_wait : int = TURN_WAIT_RESET

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func trigger(character : Node2D):
	var char : Node2D = get_parent().get_parent()

	if char.name == "Player":
		char.reduce_stamina(cost)
		char.increase_stamina(STAMINA_GAIN_ON_ACTION)
		curr_turn_wait = TURN_WAIT_RESET-1

	
	match type:
		action_type.ATTACK:
			print("ATTACK ACTION PERFORMED")
			if char.curse_blinded and !choose([true, false]):
				print("ATTACK MISSSED")
			else:
				character.take_damage(damage)
		action_type.HEAL:
			print("HEAL ACTION PERFORMED")
			character.heal(heal_amnt)
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
