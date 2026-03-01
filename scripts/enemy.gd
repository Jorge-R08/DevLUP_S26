extends Node2D

signal attack_started
signal attack_finished

const bullet_scene = preload("res://Scenes/Bullet.tscn")
@onready var shoot_timer: Timer = $ShootTimer
@onready var bullet_attack_timer: Timer = $BulletAttackTimer
@onready var rotator: Node2D = $Rotator

const rotate_speed := 100.0
const shooter_timer_wait_time := 0.2
const bullet_attack_countdown := 5
const spawn_point_count := 4
const radius := 200.0

var attack_running := false

func _ready() -> void:
	var step := TAU / spawn_point_count
	for i in range(spawn_point_count):
		var sp := Node2D.new()
		var pos := Vector2(radius, 0).rotated(step * i)
		sp.position = pos
		sp.rotation = pos.angle()
		rotator.add_child(sp)

	shoot_timer.wait_time = shooter_timer_wait_time
	bullet_attack_timer.wait_time = bullet_attack_countdown
	shoot_timer.stop()
	bullet_attack_timer.stop()

func start_attack_one() -> void:
	print("ENEMY ATTACK STARTED")
	attack_running = true
	attack_started.emit()
	hideTexture()
	shoot_timer.start()
	bullet_attack_timer.start()

func _process(delta: float) -> void:
	if not attack_running:
		return
	rotator.rotation_degrees = fmod(rotator.rotation_degrees + rotate_speed * delta, 360.0)

func _on_shoot_timer_timeout() -> void:
	if not attack_running:
		return
	for s in rotator.get_children():
		var bullet = bullet_scene.instantiate()
		get_tree().root.add_child(bullet)
		bullet.position = s.global_position
		bullet.rotation = s.global_rotation

func _on_bullet_attack_timer_timeout() -> void:
	shoot_timer.stop()
	bullet_attack_timer.stop()
	attack_running = false
	print("ENEMY ATTACK FINISHED")
	attack_finished.emit()

func hideTexture() -> void:
	$TextureButton.hide()
	$TextureButton2.hide()
