class_name Weapon extends Node3D

@export var cam: Camera3D
@export var weapon: Node3D
@export var fire_point: Node3D
@export var line_scene: PackedScene
@export var muzzle_flash_texture: Texture2D

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

	# muzzle_flash.rotation_degrees.z += 400.0 * dt

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
	weapon.rotation_degrees.z = -10.0
	rotation_offset.x = 10.0

	var muzzle_flash = Sprite3D.new()
	get_tree().current_scene.add_child(muzzle_flash)
	muzzle_flash.scale = Vector3.ONE * 7.5
	muzzle_flash.texture = muzzle_flash_texture
	muzzle_flash.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	muzzle_flash.global_position = fire_point.global_position
	muzzle_flash.look_at(cam.global_position)
	muzzle_flash.rotation_degrees.z = randf_range(0, 360)

	var hitscan_line = line_scene.instantiate() as LineRenderer
	hitscan_line.startThickness = 0.2
	hitscan_line.endThickness = 0.2
	hitscan_line.points[0] = fire_point.global_position
	if ray.is_colliding():
		hitscan_line.points[1] = ray.get_collision_point()
	else:
		hitscan_line.points[1] = ray.to_global(ray.target_position)

	cam.position.z = -0.75

	get_tree().current_scene.add_child(hitscan_line)
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property(muzzle_flash, "modulate:a", 0, 0.15)
	tween.tween_property(muzzle_flash, "scale", Vector3.ZERO, 0.15)
	tween.tween_property(hitscan_line, "startThickness", 0, 0.15)
	tween.tween_property(hitscan_line, "endThickness", 0, 0.15)
	tween.tween_property(cam, "position:z", 0.0, 0.1)
	tween.chain().tween_callback(hitscan_line.queue_free)
	tween.tween_callback(muzzle_flash.queue_free)
