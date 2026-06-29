class_name WeaponManager extends Node

@export var cam: Camera
@export var equipped_weapon: Weapon

func _ready() -> void:
	equipped_weapon.cam = cam

func _process(dt: float) -> void:
	# time += dt
	# pivot.global_rotation_degrees = cam.global_rotation_degrees
	# animation_pivot.rotation_degrees = rotation_offset
	# weapon.rotation_degrees.z = lerp(weapon.rotation_degrees.z, 0.0, 5.0 * dt)
	# rotation_offset.x = lerp(rotation_offset.x, 0.0, 5.0 * dt)

	if Input.is_action_just_pressed("mouse_left"):
		equipped_weapon.trigger_fire()
	if Input.is_action_just_pressed("mouse_right"):
		equipped_weapon.secondary_fire()
	if Input.is_action_just_released("mouse_right"):
		equipped_weapon.secondary_fire_released()

	# if is_winding_up:
	# 	cam_pivot.shake(0.02, 0.01)
	# 	animation_pivot.rotation_degrees.x = 10.0
	# 	weapon.rotation_degrees.z = -60.0

# func _on_animation_timer_timeout() -> void:
# 	var mat = (weapon.get_node("Cube_004") as MeshInstance3D).mesh.surface_get_material(0)
# 	if mat:
# 		var unique = mat.duplicate()
# 		unique.uv1_offset.y += 0.1
# 		(weapon.get_node("Cube_004") as MeshInstance3D).mesh.surface_set_material(0, unique)

# func spin():
# 	weapon.rotation_degrees.z = -540.0
