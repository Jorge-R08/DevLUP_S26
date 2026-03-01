extends Area2D

const speed = 100

signal player_hit

func _process(delta):
	position += transform.x * speed * delta
	
func _on_KillTimer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("mc"):
		print("HIT PLAYER")
		body._on_bullet_player_hit()
		queue_free()

	
