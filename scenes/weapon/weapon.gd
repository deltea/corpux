class_name Weapon extends Node3D

@export var cam: Camera3D
@export var weapon: Node3D
@export var fire_point: Node3D
# @export var line_scene: PackedScene
@export var hitscan_line: LineRenderer
@export var muzzle_flash: Sprite3D

@onready var pivot: Node3D = $Pivot
@onready var animation_pivot: Node3D = $Pivot/AnimationPivot
@onready var ray: RayCast3D = $Pivot/RayCast

var rotation_offset: Vector3
var time = 0

func _ready() -> void:
	muzzle_flash.visible = false
	top_level = true
	muzzle_flash.look_at(cam.global_position)

func _process(dt: float) -> void:
	time += dt
	pivot.global_rotation_degrees = cam.global_rotation_degrees
	animation_pivot.rotation_degrees = rotation_offset
	global_position = cam.global_position
	weapon.rotation_degrees.z = lerp(weapon.rotation_degrees.z, 0.0, 5.0 * dt)
	rotation_offset.x = lerp(rotation_offset.x, 0.0, 5.0 * dt)

	muzzle_flash.rotation_degrees.z += 400.0 * dt

	if Input.is_action_just_pressed("mouse_left"):
		fire()
	if Input.is_action_just_pressed("mouse_right"):
		spin()

func _physics_process(dt: float) -> void:
	animation_pivot.position.y = sin(time * 4.0) * 0.03
	hitscan_line.points[0] = fire_point.global_position

func _on_animation_timer_timeout() -> void:
	var mat = (weapon.get_node("Cube_004") as MeshInstance3D).mesh.surface_get_material(0)
	if mat:
		var unique = mat.duplicate()
		unique.uv1_offset.y += 0.1
		(weapon.get_node("Cube_004") as MeshInstance3D).mesh.surface_set_material(0, unique)

func spin():
	weapon.rotation_degrees.z = -540.0

func fire():
	weapon.rotation_degrees.z = -10.0
	rotation_offset.x = 10.0
	muzzle_flash.visible = true
	hitscan_line.visible = true

	# var line = line_scene.instantiate() as LineRenderer
	if ray.is_colliding():
		hitscan_line.points[1] = ray.get_collision_point()
	else:
		hitscan_line.points[1] = ray.to_global(ray.target_position)

	# get_tree().current_scene.add_child(line)
	# get_tree().create_timer(0.1).connect("timeout", func())
	get_tree().create_timer(0.1).connect("timeout", func():
		muzzle_flash.visible = false
		hitscan_line.visible = false
	)
