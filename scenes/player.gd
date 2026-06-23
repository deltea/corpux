class_name Player extends CharacterBody3D

@export var max_speed = 12
@export var deceleration = 50
@export var acceleration = 100
@export var cam_pivot: Camera

@export var jump_height = 1.7
@export var cam_sensitivity = 0.01
@export var gravity = 20.0

var dir = Vector3.ZERO
var dash_dir = Vector3.ZERO
var is_dashing = false

func _physics_process(dt: float):
	if not is_on_floor():
		velocity.y -= gravity * dt

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = sqrt(4 * jump_height * gravity)

	var input = Input.get_vector("left", "right", "forward", "backward")
	dir = (cam_pivot.transform.basis * Vector3(input.x, 0, input.y)).normalized()
	if Input.is_action_just_pressed("dash") and dir != Vector3.ZERO:
		$DashTimer.start()
		is_dashing = true
		dash_dir = dir

	if is_dashing:
		velocity.x = dash_dir.x * 50
		velocity.z = dash_dir.z * 50
		velocity.y = 0
	else:
		if dir:
			velocity.x = move_toward(velocity.x, dir.x * max_speed, acceleration * dt)
			velocity.z = move_toward(velocity.z, dir.z * max_speed, acceleration * dt)
		else:
			velocity.x = move_toward(velocity.x, 0, deceleration * dt)
			velocity.z = move_toward(velocity.z, 0, deceleration * dt)

	move_and_slide()

func _on_dash_timer_timeout() -> void:
	is_dashing = false
	velocity.x = dash_dir.x * 20
	velocity.z = dash_dir.z * 20
	velocity.y = 0
