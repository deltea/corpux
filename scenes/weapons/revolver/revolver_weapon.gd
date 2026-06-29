class_name RevolverWeapon extends Weapon

@export var fire_point: Node3D
@export var line_scene: PackedScene
@export var muzzle_flash_texture: Texture2D
@export var hit_particle_scene: PackedScene

@onready var ray: RayCast3D = $RayCast
@onready var display: MeshInstance3D = $Pivot/revolver/Cube_004
@onready var mesh: Node3D = $Pivot/revolver
@onready var pivot: Node3D = $Pivot

var time = 0
var is_winding_up = false

var original_mesh_rot: Vector3
var target_mesh_rot: Vector3

var original_pivot_rot: Vector3
var target_pivot_rot: Vector3
var original_pos: Vector3

func _ready() -> void:
	super._ready()
	original_mesh_rot = mesh.rotation_degrees
	target_mesh_rot = original_mesh_rot
	original_pivot_rot = rotation_degrees
	target_pivot_rot = original_pivot_rot
	original_pos = position

func _process(dt: float) -> void:
	time += dt
	mesh.rotation_degrees = lerp(mesh.rotation_degrees, target_mesh_rot, 5.0 * dt)
	pivot.rotation_degrees = lerp(pivot.rotation_degrees, target_pivot_rot, 5.0 * dt)
	position.y = original_pos.y + sin(time * 3.0) * 0.05

func fire():
	super.fire()

	mesh.rotation_degrees.z = -12.0
	pivot.rotation_degrees.x = 15.0

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
	var endpoint: Vector3
	if ray.is_colliding():
		endpoint = ray.get_collision_point()
		var collider = ray.get_collider()
		if collider is Enemy:
			collider.take_damage(1.0)
	else:
		endpoint = ray.to_global(ray.target_position)
	hitscan_line.points[1] = endpoint

	cam.rotation_degrees.z = 1.5 if randf() > 0.5 else -1.5

	if ray.is_colliding():
		var hit_particle = hit_particle_scene.instantiate() as GPUParticles3D
		get_tree().current_scene.add_child(hit_particle)
		hit_particle.global_position = endpoint
		hit_particle.emitting = true
		hit_particle.connect("finished", hit_particle.queue_free)

	get_tree().current_scene.add_child(hitscan_line)
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property(muzzle_flash, "modulate:a", 0, 0.11)
	tween.tween_property(muzzle_flash, "scale", Vector3.ZERO, 0.1)
	tween.tween_property(hitscan_line, "startThickness", 0, 0.15)
	tween.tween_property(hitscan_line, "endThickness", 0, 0.15)
	tween.tween_property(cam, "rotation_degrees:z", 0.0, 0.1)
	tween.chain().tween_callback(hitscan_line.queue_free)
	tween.tween_callback(muzzle_flash.queue_free)

func secondary_fire():
	# wind up
	mesh.rotation_degrees.z = -540.0

func secondary_fire_release():
	# throw the gun
	pass

func _on_animation_timer_timeout() -> void:
	var mat = display.mesh.surface_get_material(0)
	if mat:
		var unique = mat.duplicate()
		unique.uv1_offset.y += 0.1
		display.mesh.surface_set_material(0, unique)
