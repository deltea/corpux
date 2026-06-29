class_name Player extends CharacterBody3D

const FRICTION = 6.0
const AIR_FRICTION = 4.5
const MAX_SPEED = 20.0
const GROUND_ACCEL = 14.0
const GROUND_DECEL = 10.0
const AIR_ACCEL = 14.0
const DASH_SPEED = 80.0
const DASH_ACCEL = 100.0
const WALL_JUMP_PUSHBACK = 40.0
const WALL_JUMP_FORCE = 15.0
const JUMP_HEIGHT = 2.0
const GRAVITY = 28.0

@export var cam_pivot: Camera

@onready var crt: ColorRect = $"../CanvasLayer/CRT"
@onready var blur: ColorRect = $"../CanvasLayer/Blur"

var dt = 0
var wishdir = Vector3.ZERO
var vel = Vector3.ZERO
var dash_dir = Vector3.ZERO
var is_grounded = false
var is_dashing = false

func _process(_dt: float) -> void:
	crt.material.set_shader_parameter("luma_smear_px", 1.0 + vel.length() / 10.0)
	blur.material.set_shader_parameter("intensity", vel.length() / 50.0)

func _physics_process(delta: float):
	dt = delta

	var input = Input.get_vector("left", "right", "forward", "backward")
	wishdir = Vector3(input.x, 0, input.y).rotated(Vector3.UP, cam_pivot.rotation.y).normalized()

	check_grounded()

	if is_grounded: ground_move()
	else: air_move()

	if Input.is_action_just_pressed("jump") and is_on_wall() and not is_grounded:
		var normal = get_wall_normal()
		vel -= normal * minf(vel.dot(-normal), 0.0)
		vel.y = WALL_JUMP_FORCE
		vel.x = normal.x * WALL_JUMP_PUSHBACK
		vel.z = normal.z * WALL_JUMP_PUSHBACK

	if Input.is_action_just_pressed("dash") and wishdir != Vector3.ZERO:
		start_dash()

	velocity = vel
	move_and_slide()

func ground_move():
	apply_friction(FRICTION)
	if is_dashing:
		accelerate(dash_dir, DASH_SPEED, DASH_ACCEL)
	else:
		accelerate(wishdir, MAX_SPEED, GROUND_ACCEL)
	if Input.is_action_just_pressed("jump"):
		vel.y = sqrt(4 * JUMP_HEIGHT * GRAVITY)

func air_move():
	if is_dashing:
		accelerate(dash_dir, DASH_SPEED, DASH_ACCEL)
	else:
		if wishdir == Vector3.ZERO:
			apply_friction(AIR_FRICTION)
		accelerate(wishdir, MAX_SPEED, AIR_ACCEL)
	vel.y -= GRAVITY * dt

func start_dash():
	$DashTimer.start()
	is_dashing = true
	dash_dir = wishdir

func accelerate(dir: Vector3, wishspeed: float, accel: float):
	var curr_speed = vel.dot(dir)
	var add_speed = wishspeed - curr_speed
	if add_speed <= 0: return
	var accel_speed = accel * dt * wishspeed
	if accel_speed > add_speed: accel_speed = add_speed

	vel.x += accel_speed * dir.x
	vel.z += accel_speed * dir.z

func apply_friction(friction: float):
	var v = Vector3(vel.x, 0, vel.z)
	var last_speed = v.length()

	var control = GROUND_DECEL if last_speed < GROUND_DECEL else last_speed
	var drop = control * friction * dt

	var new_speed = maxf(last_speed - drop, 0.0)
	if last_speed > 0: new_speed /= last_speed

	vel.x *= new_speed
	vel.z *= new_speed

func check_grounded():
	if is_grounded != is_on_floor():
		if is_grounded:
			is_grounded = false
		else:
			is_grounded = true

func _on_dash_timer_timeout() -> void:
	is_dashing = false
	vel.x = 0
	vel.z = 0
	vel.y = 0
