extends Control

@onready var dialogue_manager := get_node("DialogueManager") as DialogueManager

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
