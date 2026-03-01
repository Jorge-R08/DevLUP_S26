extends Node2D

signal action_performed

const MIN_MOB_THINK_TIME = 0.7
const MAX_MOB_THINK_TIME = 1.6
const AFTER_ACTION_WAIT_TIME = 1

@onready var _action_buttons: Node = $UI/action_buttons
@export var dialogue_manager: DialogueManager 

@export var player_char : Node2D
@export var mob_char : Node2D


enum characters {
	PLAYER,
	MOB,
	NULL
}

var game_over : bool = false
var curr_char : characters = characters.NULL


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Game Starting")
	#await get_tree().create_timer(1).timeout
	#dialogue_manager.show_messages([
		#"let's see...",
		#"...",
	#])	
	next_turn()

func next_turn():
	if game_over:
		return

	if curr_char == characters.NULL:
		player_char.start_turn()
		curr_char = characters.PLAYER
		for btn in _action_buttons.get_children():
			btn.disabled = false
	elif curr_char == characters.PLAYER:
		player_char.end_turn()
		mob_char.start_turn()
		curr_char = characters.MOB
	elif curr_char == characters.MOB:
		mob_char.end_turn()
		player_char.start_turn()
		curr_char = characters.PLAYER
		for btn in _action_buttons.get_children():
			btn.disabled = false
	
	if curr_char == characters.PLAYER:
		await action_performed
		await  get_tree().create_timer(AFTER_ACTION_WAIT_TIME).timeout
	elif curr_char == characters.MOB:
		var wait_time = randf_range(MIN_MOB_THINK_TIME, MAX_MOB_THINK_TIME)
		await  get_tree().create_timer(wait_time).timeout
		#mob_char.perform_action()
		print("MOB ATTACK AAAAAAAAAAAAAA")
		await  get_tree().create_timer(AFTER_ACTION_WAIT_TIME).timeout
		
	next_turn()

func _on_slash_btn_pressed() -> void:
	player_char.actions["slash"].trigger(mob_char)
	action_performed.emit()

func _on_slap_btn_pressed() -> void:
	player_char.actions["slap"].trigger(mob_char)
	action_performed.emit()

func _on_heal_btn_pressed() -> void:
	player_char.actions["heal"].trigger(player_char)
	action_performed.emit()

func _on_biden_blast_btn_pressed() -> void:
	player_char.actions["biden_blast"].trigger(mob_char)
	action_performed.emit()

func _on_pharaoh_btn_pressed() -> void:
	player_char.actions["pharaohs_curse"].trigger(mob_char)
	action_performed.emit()

func _on_action_performed() -> void:
	for btn in _action_buttons.get_children():
		btn.disabled = true


"""
#dialogue use sample 
# Called when the funny button is pressed
func _on_FunnyButton_pressed() -> void:
	dialogue_manager.show_messages([
		"So,{p=0.5} you decided for a funny message...",
		"let's see...",
		"...",
		"Bro,{p=0.5} you are putting me on the spotlight",
		"NO IM NOT NERVOUS, YOU ARE NERVOUS, SHUT UP!"
	])

# Called when the sad button is pressed
func _on_SadButton_pressed() -> void:
	dialogue_manager.show_messages([
		"I don't think we need more sad stuff so...",
		"[wave]I'm gonna sing a song instead~[/wave]",
		"[wave]About{p=1.0} eh...[/wave]",
		"nevermind..."
	])

# Called when the weird button is pressed
func _on_WeirdButton_pressed() -> void:
	dialogue_manager.show_messages([
		"Anatidaephobia is the fear that, somewhere,{p=0.2} at any given time",
		"[wave]a duck is watching you...[/wave]",
		"MENACINGLY",
		"But seriously, if a duck was randomly watching me{p=0.2} I would freak out too...",
		"At least it's not a goose,{p=0.2} now THAT's [shake]terrifying[/shake]"
	])
"""
