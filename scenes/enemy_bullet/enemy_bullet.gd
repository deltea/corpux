class_name EnemyBullet extends Area3D


const SPEED = 32.0


@onready var mesh: MeshInstance3D = $MeshInstance3D


var dir = Vector2.RIGHT
var original_color: Color


func _ready() -> void:
	original_color = mesh.material_override.albedo_color


func _process(dt: float) -> void:
	position += dir * SPEED * dt
	rotation_degrees.x = snappedf(Clock.time * 2 * 90.0, 45.0)
	rotation_degrees.z = snappedf(Clock.time * 2 * 90.0, 45.0)


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		Events.death.emit()
	elif not body is Enemy:
		queue_free()


func _on_flash_timer_timeout() -> void:
	if mesh.material_override.albedo_color == Color.WHITE:
		mesh.material_override.albedo_color = original_color
		mesh.material_override.emission = original_color
	else:
		mesh.material_override.albedo_color = Color.WHITE
		mesh.material_override.emission = Color.WHITE
