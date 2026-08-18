class_name Utils extends Node


static func format_time(time: float) -> String:
	var minutes: int = int(time) / 60
	var seconds: int = int(time) % 60
	var milliseconds: int = int((time - int(time)) * 1000)
	return "%02d:%02d.%03d" % [minutes, seconds, milliseconds]


static func get_rank(time: float, cutoffs: Dictionary[String, float]) -> String:
	for rank in (cutoffs.keys() as Array[String]):
		if time <= cutoffs[rank]:
			return rank
	return cutoffs.keys()[-1]


func get_screen_rect(aabb: AABB) -> Rect2:
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
		var world_pt := aabb.position * pt
		# var world_pt :=

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
