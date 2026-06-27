class_name Weapon extends Node3D

@export var cam: Camera3D
@export var weapon: Node3D
@export var fire_point: Node3D
@export var line_scene: PackedScene

@onready var pivot: Node3D = $Pivot
@onready var animation_pivot: Node3D = $Pivot/AnimationPivot
@onready var ray: RayCast3D = $Pivot/RayCast

var rotation_offset: Vector3
var time = 0

func _ready() -> void:
	top_level = true

func _process(dt: float) -> void:
	time += dt
	pivot.global_rotation_degrees = cam.global_rotation_degrees
	animation_pivot.rotation_degrees = rotation_offset
	global_position = cam.global_position
	weapon.rotation_degrees.z = lerp(weapon.rotation_degrees.z, 0.0, 5.0 * dt)
	rotation_offset.x = lerp(rotation_offset.x, 0.0, 5.0 * dt)

	if Input.is_action_just_pressed("mouse_left"):
		fire()
	if Input.is_action_just_pressed("mouse_right"):
		spin()

func _physics_process(dt: float) -> void:
	animation_pivot.position.y = sin(time * 4.0) * 0.03

func _on_animation_timer_timeout() -> void:
	var mat = (weapon.get_node("Cube_004") as MeshInstance3D).mesh.surface_get_material(0)
	if mat:
		var unique = mat.duplicate()
		unique.uv1_offset.y += 0.1
		(weapon.get_node("Cube_004") as MeshInstance3D).mesh.surface_set_material(0, unique)

func spin():
	weapon.rotation_degrees.z = -540.0

func fire():
	weapon.rotation_degrees.z = -15.0
	rotation_offset.x = 25.0

	var line = line_scene.instantiate() as LineRenderer
	line.points[0] = fire_point.global_position
	if ray.is_colliding():
		line.points[1] = ray.get_collision_point()
	else:
		line.points[1] = ray.to_global(ray.target_position)

	get_tree().current_scene.add_child(line)
	get_tree().create_timer(0.1).connect("timeout", line.queue_free)
