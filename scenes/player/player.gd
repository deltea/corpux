class_name Player extends CharacterBody3D

const stomp_particles_scene = preload("res://scenes/particles/stomp_particles.tscn")
const dash_particles_scene = preload("res://scenes/particles/dash_particles.tscn")

const CAM_TILT = 0.0
const MOUSE_SENS = 1.0
const MAX_SPEED = 32.0
const DECELERATION = 50.0
const ACCELERATION = 100.0
const WALL_JUMP_PUSHBACK = 30.0
const WALL_JUMP_FORCE = 20.0
const JUMP_HEIGHT = 5.0
const BOUNCE_HEIGHT = 50.0
const SUPER_DASH_HEIGHT = 1.5
const SUPER_DASH_FORCE = 60.0
const SUPER_DASH_GRAVITY = 60.0
const SUPER_DASH_DECELERATION = 40.0
const DASH_FORCE = 120.0
const DASH_COUNT = 3
const MAX_DASH_COUNT = 6
const GRAVITY = 20.0
const WALL_MAX_Y_VEL = 2.5
const WALL_MAX_Z_VEL = 1.0
const SLAM_VELOCITY = 160.0

@onready var head: Node3D = $Head

var mouse_delta = Vector2.ZERO
var slam_particles: GPUParticles3D

var dir = Vector3.ZERO
var dash_dir = Vector3.ZERO
var is_dashing = false
var is_super_dashing = false
var is_slamming = false
var is_grounded = false
var is_walled = false
var dashes_left = DASH_COUNT

var head_tween: Tween

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Events.end_level.connect(_on_end_level)
	Events.death.connect(_on_death)
	Events.turn_head_to.connect(_on_turn_head_to)
	Events.add_dash.connect(_on_add_dash)
	set_dashes_left(DASH_COUNT)

func _process(dt: float) -> void:
	GlobalCanvas.set_smear(velocity.length() / 15.0)

func _physics_process(dt: float):
	check_grounded()
	check_walled()

	if is_grounded:
		set_dashes_left(DASH_COUNT)

	if not is_grounded and not is_slamming:
		if is_super_dashing:
			velocity.y -= SUPER_DASH_GRAVITY * dt
		else:
			velocity.y -= GRAVITY * dt

	if Input.is_action_just_pressed("jump") and is_grounded:
		velocity.y = sqrt(2 * JUMP_HEIGHT * GRAVITY)
	elif is_walled and not is_grounded:
		if Input.is_action_just_pressed("jump"):
			var normal = get_wall_normal()
			velocity.y = WALL_JUMP_FORCE
			velocity.x = normal.x * WALL_JUMP_PUSHBACK
			velocity.z = normal.z * WALL_JUMP_PUSHBACK

	var input = Input.get_vector("left", "right", "forward", "backward")
	dir = Vector3(input.x, 0, input.y).rotated(Vector3.UP, rotation.y).normalized()
	if Input.is_action_just_pressed("dash") and dir != Vector3.ZERO:
		dash()

	if is_dashing:
		velocity.x = dash_dir.x * DASH_FORCE
		velocity.z = dash_dir.z * DASH_FORCE
		velocity.y = 0

		if Input.is_action_just_pressed("jump") and is_grounded:
			super_dash()
	else:
		if is_super_dashing:
			if dir:
				velocity.x = move_toward(velocity.x, dir.x * 60.0, ACCELERATION * dt)
				velocity.z = move_toward(velocity.z, dir.z * 60.0, ACCELERATION * dt)
			else:
				velocity.x = move_toward(velocity.x, 0, SUPER_DASH_DECELERATION * dt)
				velocity.z = move_toward(velocity.z, 0, SUPER_DASH_DECELERATION * dt)
		else:
			if dir:
				velocity.x = move_toward(velocity.x, dir.x * MAX_SPEED, ACCELERATION * dt)
				velocity.z = move_toward(velocity.z, dir.z * MAX_SPEED, ACCELERATION * dt)
			else:
				velocity.x = move_toward(velocity.x, 0, DECELERATION * dt)
				velocity.z = move_toward(velocity.z, 0, DECELERATION * dt)

	if not is_grounded and Input.is_action_just_pressed("slam"):
		slam()

	stair_step_up()

	move_and_slide()

func dash():
	if dashes_left > 0:
		set_dashes_left(dashes_left - 1)
		$DashTimer.start()
		is_dashing = true
		dash_dir = dir

		var dash_particles = dash_particles_scene.instantiate() as GPUParticles3D
		add_child(dash_particles)
		dash_particles.position += Vector3.LEFT * dash_dir.rotated(Vector3.UP, -rotation.y) * 6
		dash_particles.global_rotation.y = Vector2(-dash_dir.x, dash_dir.z).angle() - PI/2
		await Clock.wait(0.15)
		dash_particles.queue_free()
	else:
		print("no dashes left")

func check_grounded():
	if is_grounded != is_on_floor():
		if is_grounded:
			is_grounded = false
		else:
			is_grounded = true
			is_super_dashing = false
			stop_slam()

func check_walled():
	if is_walled != is_on_wall():
		if is_walled:
			is_walled = false
		else:
			is_walled = true
			is_super_dashing = false
			stop_slam()
			# set_dashes_left(DASH_COUNT)

func stop_slam():
	if slam_particles: slam_particles.queue_free()
	is_slamming = false

func super_dash():
	$DashTimer.stop()
	is_dashing = false
	is_super_dashing = true
	velocity.x = dash_dir.x * SUPER_DASH_FORCE
	velocity.z = dash_dir.z * SUPER_DASH_FORCE
	velocity.y = sqrt(4 * SUPER_DASH_HEIGHT * SUPER_DASH_GRAVITY)
	set_dashes_left(dashes_left - 1)

func slam():
	$DashTimer.stop()
	is_slamming = true
	is_super_dashing = false
	is_dashing = false
	velocity.y = -SLAM_VELOCITY
	velocity.x = 0
	velocity.z = 0

	if slam_particles: slam_particles.queue_free()
	slam_particles = dash_particles_scene.instantiate() as GPUParticles3D
	add_child(slam_particles)
	slam_particles.global_rotation.x = PI/2


func get_look_dir():
	return Vector3.FORWARD.rotated(Vector3.RIGHT, head.rotation.x).rotated(Vector3.UP, rotation.y).normalized()

func stair_step_up():
	if dir == Vector3.ZERO:
		return

	var body_test_params = PhysicsTestMotionParameters3D.new()
	var body_test_result = PhysicsTestMotionResult3D.new()

	var test_transform = global_transform
	var distance = dir * 1.0
	body_test_params.from = self.global_transform
	body_test_params.motion = distance

	if !PhysicsServer3D.body_test_motion(self.get_rid(), body_test_params, body_test_result):
		return

	var remainder = body_test_result.get_remainder()
	test_transform = test_transform.translated(body_test_result.get_travel())

	var step_up = 1.0 * Vector3.UP
	body_test_params.from = test_transform
	body_test_params.motion = step_up
	PhysicsServer3D.body_test_motion(self.get_rid(), body_test_params, body_test_result)
	test_transform = test_transform.translated(body_test_result.get_travel())

	body_test_params.from = test_transform
	body_test_params.motion = remainder
	PhysicsServer3D.body_test_motion(self.get_rid(), body_test_params, body_test_result)
	test_transform = test_transform.translated(body_test_result.get_travel())

	if body_test_result.get_collision_count() != 0:
		remainder = body_test_result.get_remainder().length()

		var wall_normal = body_test_result.get_collision_normal()
		var dot_div_mag = dir.dot(wall_normal) / (wall_normal * wall_normal).length()
		var projected_vector = (dir - dot_div_mag * wall_normal).normalized()

		body_test_params.from = test_transform
		body_test_params.motion = remainder * projected_vector
		PhysicsServer3D.body_test_motion(self.get_rid(), body_test_params, body_test_result)
		test_transform = test_transform.translated(body_test_result.get_travel())

	body_test_params.from = test_transform
	body_test_params.motion = 1.0 * -Vector3.UP

	if !PhysicsServer3D.body_test_motion(self.get_rid(), body_test_params, body_test_result):
		return

	test_transform = test_transform.translated(body_test_result.get_travel())

	var surface_normal = body_test_result.get_collision_normal()
	if (snappedf(surface_normal.angle_to(Vector3.UP), 0.001) > floor_max_angle):
		return

	var global_pos = global_position
	var step_up_dist = test_transform.origin.y - global_pos.y

	velocity.y = 0
	global_pos.y = test_transform.origin.y
	global_position = global_pos

func bounce():
	velocity.y = sqrt(2 * BOUNCE_HEIGHT * GRAVITY)

func set_dashes_left(value: int):
	dashes_left = clampi(value, 0, MAX_DASH_COUNT)
	Events.player_dash_changed.emit(dashes_left)

func _on_add_dash():
	set_dashes_left(dashes_left + 1)

func _on_turn_head_to(target_pos: Vector3):
	var to_target = target_pos - global_position
	var target_angle = rad_to_deg(atan2(-to_target.x, -to_target.z))
	if head_tween: head_tween.kill()
	head_tween = create_tween().set_parallel().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	head_tween.tween_property(self, "rotation_degrees:y", target_angle, 1.0)

func _on_dash_timer_timeout() -> void:
	is_dashing = false
	velocity.x = dash_dir.x * 20
	velocity.z = dash_dir.z * 20
	velocity.y = 0

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("esc"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion and (not head_tween or not head_tween.is_running()):
			rotate_y(-event.relative.x * MOUSE_SENS * 0.002)
			head.rotate_x(-event.relative.y * MOUSE_SENS * 0.002)
			head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _on_end_level():
	process_mode = Node.PROCESS_MODE_DISABLED
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_death():
	process_mode = Node.PROCESS_MODE_DISABLED
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
