class_name Camera extends Node3D

@export var cam_tilt = 0
@export var player: Player
@export var y_offset = 0.5
@export var mouse_sens = 1.0

@onready var cam: Camera3D = $Camera

var mouse_delta = Vector2.ZERO

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(dt: float) -> void:
	global_position = player.global_position + Vector3(0, y_offset, 0)

	rotate_y(-mouse_delta.x * 0.002)
	cam.rotate_x(-mouse_delta.y * 0.002)
	cam.rotation.x = clamp(cam.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	mouse_delta = Vector2.ZERO

	var input = Input.get_vector("left", "right", "forward", "backward")
	if input.x:
			cam.rotation_degrees.z = move_toward(cam.rotation_degrees.z, -input.x * cam_tilt, 40 * dt)
	else:
			cam.rotation_degrees.z = move_toward(cam.rotation_degrees.z, 0, 40 * dt)

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("esc"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			mouse_delta += event.relative * mouse_sens
