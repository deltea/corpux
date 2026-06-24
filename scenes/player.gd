class_name Player extends CharacterBody3D

@export var max_speed = 12.0
@export var deceleration = 50.0
@export var acceleration = 100.0
@export var cam_pivot: Camera
@export var wall_jump_pushback = 30.0
@export var wall_jump_force = 15.0
@export var jump_height = 1.8
@export var super_dash_height = 1.5
@export var super_dash_force = 60.0
@export var super_dash_gravity = 60.0
@export var super_dash_deceleration = 40.0
@export var dash_force = 50.0
@export var gravity = 25.0
@export var wall_max_y_vel = 2.5
@export var wall_max_z_vel = 1.0
@export var slam_velocity = 140.0

var dir = Vector3.ZERO
var dash_dir = Vector3.ZERO
var is_dashing = false
var is_super_dashing = false
var is_slamming = false

func _physics_process(dt: float):
	if not is_on_floor() and not is_slamming:
		if is_super_dashing:
			velocity.y -= super_dash_gravity * dt
		else:
			velocity.y -= gravity * dt

	if is_on_wall() and velocity.y < 0:
		velocity.y = clampf(velocity.y, -wall_max_y_vel, 0)
		velocity.z = clampf(velocity.z, -wall_max_z_vel, wall_max_z_vel)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = sqrt(4 * jump_height * gravity)
	elif is_on_wall() and not is_on_floor():
		if Input.is_action_just_pressed("jump"):
			var normal = get_wall_normal()
			velocity.y = wall_jump_force
			velocity.x = normal.x * wall_jump_pushback
			velocity.z = normal.z * wall_jump_pushback

	var input = Input.get_vector("left", "right", "forward", "backward")
	dir = (cam_pivot.transform.basis * Vector3(input.x, 0, input.y)).normalized()
	if Input.is_action_just_pressed("dash") and dir != Vector3.ZERO:
		$DashTimer.start()
		is_dashing = true
		dash_dir = dir

	if is_dashing:
		velocity.x = dash_dir.x * dash_force
		velocity.z = dash_dir.z * dash_force
		velocity.y = 0

		if Input.is_action_just_pressed("jump") and is_on_floor():
			super_dash()
	else:
		if is_super_dashing:
			velocity.x = move_toward(velocity.x, 0, super_dash_deceleration * dt)
			velocity.z = move_toward(velocity.z, 0, super_dash_deceleration * dt)
		else:
			if dir:
				velocity.x = move_toward(velocity.x, dir.x * max_speed, acceleration * dt)
				velocity.z = move_toward(velocity.z, dir.z * max_speed, acceleration * dt)
			else:
				velocity.x = move_toward(velocity.x, 0, deceleration * dt)
				velocity.z = move_toward(velocity.z, 0, deceleration * dt)

	if not is_on_floor() and Input.is_action_just_pressed("slam"):
		slam()

	var was_on_floor = is_on_floor()
	var was_on_wall = is_on_wall()

	move_and_slide()

	# just landed on the ground or just jumped
	if is_on_floor() != was_on_floor:
		if is_on_floor():
			is_super_dashing = false
			is_slamming = false

	if is_on_wall() != was_on_wall:
		if is_on_wall():
			is_super_dashing = false
			is_slamming = false

func super_dash():
	$DashTimer.stop()
	is_dashing = false
	is_super_dashing = true
	velocity.x = dash_dir.x * super_dash_force
	velocity.z = dash_dir.z * super_dash_force
	velocity.y = sqrt(4 * super_dash_height * super_dash_gravity)

func slam():
	$DashTimer.stop()
	is_slamming = true
	is_super_dashing = false
	is_dashing = false
	velocity.y = -slam_velocity
	velocity.x = 0
	velocity.z = 0

func _on_dash_timer_timeout() -> void:
	is_dashing = false
	velocity.x = dash_dir.x * 20
	velocity.z = dash_dir.z * 20
	velocity.y = 0
