class_name Player extends CharacterBody3D

const CAM_TILT = 0.0
const MOUSE_SENS = 1.0
const MAX_SPEED = 32.0
const DECELERATION = 50.0
const ACCELERATION = 100.0
const WALL_JUMP_PUSHBACK = 30.0
const WALL_JUMP_FORCE = 20.0
const JUMP_HEIGHT = 5.0
const SUPER_DASH_HEIGHT = 1.5
const SUPER_DASH_FORCE = 60.0
const SUPER_DASH_GRAVITY = 60.0
const SUPER_DASH_DECELERATION = 40.0
const DASH_FORCE = 120.0
const DASH_COUNT = 3
const GRAVITY = 20.0
const WALL_MAX_Y_VEL = 2.5
const WALL_MAX_Z_VEL = 1.0
const SLAM_VELOCITY = 140.0

@onready var head: Node3D = $Head

var mouse_delta = Vector2.ZERO

var dir = Vector3.ZERO
var dash_dir = Vector3.ZERO
var is_dashing = false
var is_super_dashing = false
var is_slamming = false
var is_grounded = false
var is_walled = false
var dashes_left = DASH_COUNT

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Events.end_level.connect(_on_end_level)
	Events.death.connect(_on_death)

func _process(dt: float) -> void:
	GlobalCanvas.set_smear(velocity.length() / 10.0)

func _physics_process(dt: float):
	check_grounded()
	check_walled()

	if not is_grounded and not is_slamming:
		if is_super_dashing:
			velocity.y -= SUPER_DASH_GRAVITY * dt
		else:
			velocity.y -= GRAVITY * dt

	# if is_walled and velocity.y < 0 and not is_slamming:
	# 	velocity.y = clampf(velocity.y, -WALL_MAX_Y_VEL, 0)
	# 	velocity.z = clampf(velocity.z, -WALL_MAX_Z_VEL, WALL_MAX_Z_VEL)

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
				# @param
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
		dashes_left -= 1
		$DashTimer.start()
		is_dashing = true
		dash_dir = dir
	else:
		print("no dashes left")

func check_grounded():
	if is_grounded != is_on_floor():
		if is_grounded:
			is_grounded = false
		else:
			is_grounded = true
			is_super_dashing = false
			is_slamming = false
			dashes_left = DASH_COUNT

func check_walled():
	if is_walled != is_on_wall():
		if is_walled:
			is_walled = false
		else:
			is_walled = true
			is_super_dashing = false
			is_slamming = false
			dashes_left = DASH_COUNT

func super_dash():
	$DashTimer.stop()
	is_dashing = false
	is_super_dashing = true
	velocity.x = dash_dir.x * SUPER_DASH_FORCE
	velocity.z = dash_dir.z * SUPER_DASH_FORCE
	velocity.y = sqrt(4 * SUPER_DASH_HEIGHT * SUPER_DASH_GRAVITY)
	dashes_left = DASH_COUNT

func slam():
	$DashTimer.stop()
	is_slamming = true
	is_super_dashing = false
	is_dashing = false
	velocity.y = -SLAM_VELOCITY
	velocity.x = 0
	velocity.z = 0

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
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * MOUSE_SENS * 0.002)
			head.rotate_x(-event.relative.y * MOUSE_SENS * 0.002)
			head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _on_end_level():
	await Clock.wait(0.25)
	process_mode = Node.PROCESS_MODE_DISABLED
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	GlobalCanvas.set_smear(0.0)

func _on_death():
	process_mode = Node.PROCESS_MODE_DISABLED
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	GlobalCanvas.set_smear(0.0)
