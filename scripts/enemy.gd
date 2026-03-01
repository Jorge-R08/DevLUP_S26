extends Node2D

signal attack_started(chosen_attack: int)
signal attack_finished

const bullet_scene = preload("res://Scenes/Bullet.tscn")
@onready var shoot_timer: Timer = $ShootTimer
@onready var bullet_attack_timer: Timer = $BulletAttackTimer
@onready var rotator: Node2D = $Rotator

@export var max_health : int = 100
@export var healed : bool = false
var curr_health : int = max_health
@onready var _health_bar: TextureProgressBar = $health_bar

const atttacks = [2]
const attacks_low_health = [0]

var attack = atttacks.pick_random()

var rotate_speed := 100
var shooter_timer_wait_time := 0.2
var bullet_attack_countdown := 5
var spawn_point_count := 4
var radius := 200.0

var attack_running := false

func _ready() -> void:	
	shoot_timer.wait_time = shooter_timer_wait_time
	bullet_attack_timer.wait_time = bullet_attack_countdown
	shoot_timer.stop()
	bullet_attack_timer.stop()

func start_attack_one() -> void:
	var chosen_attack = atttacks.pick_random()
	if curr_health <= 25 and not healed:
		chosen_attack = attacks_low_health.pick_random()

	print("ATTACK:", chosen_attack)
	_setup_attack_pattern(chosen_attack)

	if chosen_attack == 1 or chosen_attack == 2:
		if chosen_attack == 1:
			$TextureButton3.hide()
			$TextureButton2.hide()
		else:
			$TextureButton.hide()
			$TextureButton2.hide()
		
		attack_running = true
		attack_started.emit(chosen_attack)
		shoot_timer.start()
		bullet_attack_timer.start()
		return
	$TextureButton.hide()
	$TextureButton3.hide()
	# heal (0)
	healed = true
	attack_running = false
	attack_started.emit()
	take_damage(-20)
	await get_tree().create_timer(3.0).timeout
	attack_finished.emit()
	showTexture()

	
func _process(delta: float) -> void:
	if not attack_running:
		return
	rotator.rotation_degrees = fmod(rotator.rotation_degrees + rotate_speed * delta, 360.0)

func _on_shoot_timer_timeout() -> void:
	if not attack_running:
		return
	for s in rotator.get_children():
		var bullet = bullet_scene.instantiate()
		if s.global_rotation > 0:
			get_tree().root.add_child(bullet)
			bullet.position = s.global_position
			bullet.rotation = s.global_rotation

func _on_bullet_attack_timer_timeout() -> void:
	shoot_timer.stop()
	bullet_attack_timer.stop()
	attack_running = false
	print("ENEMY ATTACK FINISHED")
	await get_tree().create_timer(8.0).timeout
	attack_finished.emit()
	showTexture()
	
func hideTexture() -> void:
	$TextureButton.hide()
	$TextureButton2.hide()
	
func showTexture() -> void:
	$TextureButton.show()
	$TextureButton2.show()
	$TextureButton3.show()

func take_damage(dmg : int) -> void:
	curr_health = max(0, curr_health - dmg)
	_health_bar.value = curr_health
	
	if curr_health == 0:
		die()
	
func _setup_attack_pattern(chosen_attack: int) -> void:

	for c in rotator.get_children():
		c.queue_free()

	rotate_speed = 100
	spawn_point_count = 4
	var step := TAU / spawn_point_count

	if chosen_attack == 2:
		rotate_speed = 400
		spawn_point_count = 4
		step = TAU / spawn_point_count

	for i in range(spawn_point_count):
		var sp := Node2D.new()
		var pos := Vector2(radius, 0).rotated(step * i)
		sp.position = pos
		sp.rotation = pos.angle()
		rotator.add_child(sp)

func die() -> void:
	print("ENEMY DEAD")
	attack_running = false
	shoot_timer.stop()
	bullet_attack_timer.stop()

	attack_finished.emit() 

	queue_free() 
