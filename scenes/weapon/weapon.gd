class_name Weapon extends Node3D

@export var cam: Camera3D
@export var weapon: Node3D

func _ready() -> void:
	top_level = true

func _process(dt: float) -> void:
	# var target_basis := Basis.from_euler(cam.global_rotation)
	# global_basis = global_basis.slerp(target_basis, 40.0 * dt)
	global_rotation = cam.global_rotation
	global_position = cam.global_position

func _on_animation_timer_timeout() -> void:
	var mat = (weapon.get_node("Cube_004") as MeshInstance3D).mesh.surface_get_material(0)
	if mat:
		var unique = mat.duplicate()
		unique.uv1_offset.y += 0.1
		(weapon.get_node("Cube_004") as MeshInstance3D).mesh.surface_set_material(0, unique)
