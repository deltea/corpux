class_name Enemy extends StaticBody3D


@export var explosion_scene: PackedScene

@export var max_health := 2


@onready var collision_shape: CollisionShape3D = $CollisionShape3D


var health: int


func _ready() -> void:
	health = max_health


func take_damage(damage: int) -> void:
	health -= damage
	if health <= 0:
		die()
	else:
		Events.cam_shake.emit(0.01, 0.05)
		Clock.hitstop(0.1)


func die() -> void:
	queue_free()
	Events.enemy_aim_exit.emit()
	Events.enemy_died.emit()
	Events.add_dash.emit()

	var explosion := explosion_scene.instantiate() as CPUParticles3D
	get_tree().current_scene.add_child(explosion)
	explosion.position = global_position
	explosion.emitting = true
	Clock.time_stop(0.25)
	Events.flashbang.emit(0.1, 0.5)


func get_screen_rect() -> Rect2:
	var aabb := collision_shape.shape.get_debug_mesh().get_aabb()
	var camera: Camera3D = get_viewport().get_camera_3d()
	if not camera:
		return Rect2()

	var local_points: Array[Vector3] = [
		aabb.position,
		aabb.position + Vector3(aabb.size.x, 0, 0),
		aabb.position + Vector3(0, aabb.size.y, 0),
		aabb.position + Vector3(0, 0, aabb.size.z),
		aabb.position + Vector3(aabb.size.x, aabb.size.y, 0),
		aabb.position + Vector3(aabb.size.x, 0, aabb.size.z),
		aabb.position + Vector3(0, aabb.size.y, aabb.size.z),
		aabb.position + aabb.size
	]

	var screen_points: Array[Vector2] = []
	for pt in local_points:
		var world_pt := collision_shape.global_transform * pt

		if camera.is_position_behind(world_pt):
			continue

		var screen_pt := camera.unproject_position(world_pt)
		screen_points.append(screen_pt)

	if screen_points.is_empty():
		return Rect2()

	var min_x := screen_points[0].x
	var max_x := screen_points[0].x
	var min_y := screen_points[0].y
	var max_y := screen_points[0].y

	for pt in screen_points:
		min_x = min(min_x, pt.x)
		max_x = max(max_x, pt.x)
		min_y = min(min_y, pt.y)
		max_y = max(max_y, pt.y)

	var screen_pos := Vector2(min_x, min_y)
	var screen_size := Vector2(max_x - min_x, max_y - min_y)

	return Rect2(screen_pos, screen_size)


func _on_auto_aim_area_aim_entered() -> void:
	Events.enemy_aim_enter.emit(self)


func _on_auto_aim_area_aim_exited() -> void:
	Events.enemy_aim_exit.emit()
