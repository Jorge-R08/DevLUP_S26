extends Node2D

const CURSE_BLIND_TURNS = 4

@export var actions : Dictionary[String, Action]
@onready var blast: AnimatedSprite2D = $blast

@export var max_health : int = 100
@export var max_stamina : int = 50
var curr_health : int = max_health
var curr_stamina : int = max_stamina

var curr_curse_blind_turns = 0

@onready var _health_bar: TextureProgressBar = $health_bar
@onready var _stamina_bar: TextureProgressBar = $stamina_bar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var is_player : bool

var stunned : int = 0

signal player_dead

#status effects
@export var curse_blinded : bool = false

var blocking : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func start_turn():
	print("Player turn start -- Stamina: , --- HEALTH: ", curr_stamina, curr_health)
	print("Curse blinded?: --- turns?: ", curse_blinded, curr_curse_blind_turns)

func end_turn():
	print("Player turn end")
	
func take_damage(dmg : int):
	#hurt animation
	if blocking: dmg = dmg / 2
	curr_health = max(0, curr_health-dmg)
	_health_bar.value = curr_health
	if curr_health > 0:
		animation_player.play("hurt")
	else:
		animated_sprite_2d.play("die")
		player_dead.emit()
	
	
func heal(amnt : int):
	#heal animation
	curr_health = min(max_health, curr_health+amnt)
	_health_bar.value = curr_health
	
func reduce_stamina(amnt : int):
	curr_stamina = max(0, curr_stamina-amnt)
	_stamina_bar.value = curr_stamina	

func increase_stamina(amnt : int):
	curr_stamina = min(max_stamina, curr_stamina+amnt)
	_stamina_bar.value = curr_stamina	

func _on_defend_toggle_blocking(to_player : bool) -> void:
	if to_player:
		blocking = true


func _on_blast_animation_finished() -> void:
	if blast.animation == "default":
		blast.visible = false
