class_name WeaponManager extends Node3D

@export var cam: Camera
@export var equipped_weapon: Weapon

var original_pos: Vector3

func _ready() -> void:
	equipped_weapon.cam = cam
	original_pos = position

func _process(dt: float) -> void:
	if Input.is_action_pressed("mouse_left"):
		equipped_weapon.trigger_fire()
	if Input.is_action_just_pressed("mouse_right"):
		equipped_weapon.secondary_fire()
	if Input.is_action_just_released("mouse_right"):
		equipped_weapon.secondary_fire_released()

	position.y = original_pos.y + sin(Clock.time * 3.0) * 0.05
