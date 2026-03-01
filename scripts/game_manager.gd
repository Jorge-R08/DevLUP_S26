extends Node2D

signal action_performed()

const MIN_MOB_THINK_TIME = 0.7
const MAX_MOB_THINK_TIME = 1.6
const AFTER_ACTION_WAIT_TIME = 1

@onready var _action_buttons: Node = $UI/action_buttons
@export var dialogue_manager: DialogueManager 
@onready var blast: AnimatedSprite2D

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
	mob_char.find_child("think_sprite").visible = false
	blast = player_char.find_child("blast")
	next_turn()

func next_turn():
	if game_over:
		return
	
	if player_char.curse_blinded:
		print("player curse blinded")
		player_char.curr_curse_blind_turns = min(player_char.curr_curse_blind_turns+1, player_char.CURSE_BLIND_TURNS)
		if (player_char.curr_curse_blind_turns == player_char.CURSE_BLIND_TURNS):
			player_char.curse_blinded = false
			player_char.curr_curse_blind_turns = 0
	if mob_char.curse_blinded:
		mob_char.curr_curse_blind_turns = min(mob_char.curr_curse_blind_turns+1, mob_char.CURSE_BLIND_TURNS)
		if (mob_char.curr_curse_blind_turns == mob_char.CURSE_BLIND_TURNS):
			mob_char.curse_blinded = false
			mob_char.curr_curse_blind_turns = 0

	if curr_char == characters.NULL:
		player_char.start_turn()
		curr_char = characters.PLAYER
		for btn in _action_buttons.get_children():
			if (player_char.actions[btn.get_child(0).name].turn_wait == 1):
				btn.disabled = false
	elif curr_char == characters.PLAYER:
		player_char.end_turn()
		mob_char.start_turn()
		curr_char = characters.MOB
	elif curr_char == characters.MOB:
		mob_char.end_turn()
		player_char.start_turn()
		curr_char = characters.PLAYER
		
		if player_char.stunned > 0:
			print("STUNNED")
		else:
			for btn in _action_buttons.get_children():
				if (player_char.actions[btn.get_child(0).name].curr_turn_wait >= player_char.actions[btn.get_child(0).name].turn_wait):
					btn.disabled = false
							
	if curr_char == characters.PLAYER:
		if player_char.stunned <= 0:
			await action_performed
		else:
			player_char.stunned =- 1
		await  get_tree().create_timer(AFTER_ACTION_WAIT_TIME).timeout
	elif curr_char == characters.MOB:
		mob_char.find_child("think_sprite").visible = true
		mob_char.animation_player.play("think")
		var wait_time = randf_range(MIN_MOB_THINK_TIME, MAX_MOB_THINK_TIME)
		await  get_tree().create_timer(wait_time).timeout
		mob_char.animation_player.stop
		mob_char.find_child("think_sprite").visible = false
		
		var mob_action : Action = mob_char.decide_action()
		mob_action.trigger(player_char)

		
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
	player_char.actions["biden blast"].trigger(mob_char)
	action_performed.emit()
	blast.play("default")
	blast.visible = true

func _on_pharaoh_btn_pressed() -> void:
	player_char.actions["pharaohs curse"].trigger(mob_char)
	action_performed.emit()

func _on_skip_btn_pressed() -> void:
	player_char.actions["skip"].trigger(player_char)
	action_performed.emit()

func _on_defend_btn_pressed() -> void:
	player_char.actions["defend"].trigger(player_char)
	action_performed.emit()

func _on_action_performed() -> void:
	for btn in _action_buttons.get_children():
		btn.disabled = true
	for action in player_char.actions:
		player_char.actions[action].curr_turn_wait = min(player_char.actions[action].turn_wait, player_char.actions[action].curr_turn_wait+1)
	
func choose(array : Array):
	array.shuffle()
	return array[0]

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


func _on_mob_mob_dead() -> void:
	game_over = true
	if mob_char.is_tutorial_mob:
		await get_tree().create_timer(5.0).timeout
		call_deferred("_go_to_next_scene")
		
func _go_to_next_scene() -> void:
	get_tree().change_scene_to_file("res://scenes/boss_lvl.tscn")

func _on_player_player_dead() -> void:
	game_over = true

func _on_mob_summoner_dead() -> void:
	print("SUMMON YETEHAYU")
	game_over = true
