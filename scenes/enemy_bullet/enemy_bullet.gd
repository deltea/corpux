class_name EnemyBullet extends Area3D

const SPEED = 20.0

var dir = Vector2.RIGHT

func _process(dt: float) -> void:
	position += dir * SPEED * dt
	rotation_degrees.x = snappedf(Clock.time * 2 * 90.0, 45.0)
	rotation_degrees.z = snappedf(Clock.time * 2 * 90.0, 45.0)

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		Events.death.emit()
	elif not body is Enemy:
		queue_free()
