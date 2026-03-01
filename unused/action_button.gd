extends TextureButton

@export var action_name : String = "pingas"
@onready var rich_text_label: RichTextLabel = $RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rich_text_label.text = action_name
