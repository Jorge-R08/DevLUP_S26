class_name DialogueManager
extends Node

const DIALOGUE_SCENE := preload("../scenes/Dialogue.tscn")
#@onready var opacity_tween := get_tree().create_tween()
@onready var next_label := get_node("NextLabel") as Label
@export var DialoguePosition : Vector2
@export var nextLabelPosition : Vector2


signal message_requested()
signal message_completed()
signal finished()

var _messages := []
var _active_dialogue_offset := 0
var _is_active := false

var cur_dialogue_instance: Dialogue

# Hide the next label on start
func _ready() -> void:
	next_label.visible = false
	next_label.global_position = nextLabelPosition

# This input lifecycle method will be used to detect whether we press the "enter" key
func _input(event: InputEvent) -> void:
	if (
		event.is_pressed() and 
		!event.is_echo() and
		event is InputEventKey and 
		(event as InputEventKey).keycode == KEY_ENTER and
		_is_active and
		cur_dialogue_instance.message_is_fully_visible()
	):
		print("da=ialoge offset: ", _active_dialogue_offset)
		if _active_dialogue_offset < _messages.size() - 1:
			print("in the show current IF")
			_active_dialogue_offset += 1
			_show_current()
		else:
			print("in the hide IF")
			_is_active = false
			_hide()

# This will queue a set of messages, and will spawn the dialogue at the provided position
func show_messages(message_list: Array) -> void:
	if _is_active:
		return
	_is_active = true
	
	_messages = message_list
	_active_dialogue_offset = 0
	
	#create dialogue instance
	var _dialogue = DIALOGUE_SCENE.instantiate()
	get_tree().get_root().get_child(-1).get_node("UI").add_child(_dialogue)
	
	var dialogue_background : NinePatchRect = _dialogue.get_children().get(0)
	if dialogue_background.name != "Background":
		print("ERROR: THE BACKGROUND NODE IS NOT THE BACKGROUND")
	
	var dialogue_content : RichTextLabel = _dialogue.get_children().get(1)
	if dialogue_content.name != "Content":
		print("ERROR: THE CONTENT NODE IS NOT THE CONTENT")
		
	_dialogue.modulate.a = 1
	_dialogue.global_position = DialoguePosition
	_dialogue.connect("message_completed", Callable(self, "_on_message_completed"))
	cur_dialogue_instance = _dialogue
	
	#make the thing shade in with tween
	
	#FROM GODOT 3
	#opacity_tween.interpolate_property(
	#	_dialogue, "modulate:a", 0.0, 1.0, 0.2,
	#	Tween.TRANS_SINE, Tween.EASE_IN_OUT
	#)
	#
	#opacity_tween.tween_property(cur_dialogue_instance, "modulate.a", 1.0, 3)
	#opacity_tween.start()
	#await opacity_tween.tween_all_completed
	
	_show_current()

# Updates the dialogue with the message for the current offset
func _show_current() -> void:
	emit_signal("message_requested")
	next_label.visible = false
	cur_dialogue_instance.update_message(_messages[_active_dialogue_offset])

# Hide the current dialogue, and finish the process
func _hide() -> void:
	cur_dialogue_instance.disconnect("message_completed", Callable(self, "_on_message_completed"))
	cur_dialogue_instance.modulate.a = 0
	#make the thing shade out with tween
	#opacity_tween.interpolate_property(
	#	cur_dialogue_instance, "modulate:a", 1.0, 0.0, 0.2,
	#	Tween.TRANS_SINE, Tween.EASE_IN_OUT
	#)
	#opacity_tween.start()
	#await opacity_tween.tween_all_completed
	cur_dialogue_instance.queue_free()
	cur_dialogue_instance = null
	_is_active = false
	emit_signal("finished")
	next_label.visible = false
	print("after HIDE")
	

# Called when the message finishes typing on the dialogue
func _on_message_completed() -> void:
	emit_signal("message_completed")
	next_label.visible = true
