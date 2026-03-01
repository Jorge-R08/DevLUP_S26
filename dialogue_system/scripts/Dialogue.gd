class_name Dialogue
extends Control

@onready var pause_calculator := get_node("PauseCalculator") as PauseCalculator
@onready var content := get_node("Content") as RichTextLabel
@onready var type_timer := get_node("TypeTyper") as Timer
@onready var pause_timer := get_node("PauseTimer") as Timer
@onready var voice_timer: Timer = $voiceTimer

@onready var voice_player: AudioStreamPlayer = $AudioStreamPlayer

var _playing_voice := false
var at_tag := false

signal message_completed()

# Swaps the current message with the one provided, and start the typing logic
func update_message(message: String) -> void:
	# Pause detection logic
	content.text = pause_calculator.extract_pauses_from_string(message)
	content.visible_characters = 0
	
	type_timer.start()
	voice_timer.start()
	
	_playing_voice = true
	voice_player.play(0)

# Returns true if there are no pending characters to show
func message_is_fully_visible() -> bool:
	return content.visible_characters >= content.text.length() - 1

# Called when the timer responsible for showing characters calls its timeout
func _on_TypeTyper_timeout() -> void:
	if content.text[content.visible_characters - 1] == "[":
		at_tag = true
	else: if content.text[content.visible_characters - 1] == "]":
		at_tag = false
	pause_calculator.check_at_position(content.visible_characters)
	if content.visible_characters < content.text.length():
		content.visible_characters += 1
	else:
		_playing_voice = false
		type_timer.stop()
		voice_timer.stop()
		emit_signal("message_completed")
		print("message compelted")
		
func _on_voice_timer_timeout() -> void:
	if content.visible_characters < content.text.length() and (not at_tag or content.visible_characters < 5):
		voice_player.play(0)

# Called when the voice player finishes playing the voice clip
#func _on_audio_stream_player_finished() -> void:
#	print("befoer playing oice")
#	if _playing_voice:
#		print("in playing voice")
#		voice_player.play(0)

# Called when the pause calculator node requests a pause
func _on_PauseCalculator_pause_requested(duration: float) -> void:
	_playing_voice = false
	type_timer.stop()
	voice_timer.stop()
	pause_timer.wait_time = duration
	pause_timer.start()

# Called when the pause timer finishes
func _on_PauseTimer_timeout() -> void:
	_playing_voice = true
	voice_player.play(0)
	type_timer.start()
	voice_timer.start()
