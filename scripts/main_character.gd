extends CharacterBody2D

@export var speed := 400.0
var can_move := false

@export var max_health : int = 100
var curr_health : int = max_health
@onready var _health_bar: TextureProgressBar = $health_bar

var start_position: Vector2

func _ready() -> void:
	await get_tree().process_frame
	start_position = position

func set_can_move(v: bool) -> void:
	print("can_move -> ", v)
	can_move = v
	if not can_move:
		velocity = Vector2.ZERO

func _physics_process(_delta: float) -> void:
	if not can_move:
		return

	var direction := Input.get_axis("left", "right")
	velocity.x = direction * speed
	velocity.y = 0
	move_and_slide()

func _on_bullet_player_hit() -> void:
	take_damage(15)
	print(curr_health)

func take_damage(dmg : int) -> void:
	curr_health = max(0, curr_health - dmg)
	_health_bar.value = curr_health

func reset_position() -> void:
	global_position = start_position
	velocity = Vector2.ZERO
