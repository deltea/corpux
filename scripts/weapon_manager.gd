class_name WeaponManager extends Node3D

const SHAKE_DAMP_SPEED = 2.0

@export var cam: Camera
@export var equipped_weapon: Weapon

var shake_duration = 0
var shake_strength = 0
var original_pos: Vector3

func _ready() -> void:
	equip_weapon(equipped_weapon)
	original_pos = position

func equip_weapon(weapon: Weapon):
	weapon.cam = cam
	weapon.weapon_shake.connect(_on_weapon_shake)

func _process(dt: float) -> void:
	if Input.is_action_pressed("mouse_left"):
		equipped_weapon.trigger_fire()
	if Input.is_action_just_pressed("mouse_right"):
		equipped_weapon.secondary_fire()
	if Input.is_action_just_released("mouse_right"):
		equipped_weapon.secondary_fire_released()

	position.x = original_pos.x
	position.y = original_pos.y
	if shake_duration > 0:
		position.x += randf_range(0, PI*2) * shake_strength
		position.y += randf_range(0, PI*2) * shake_strength
		shake_duration -= dt * SHAKE_DAMP_SPEED
	else:
		shake_duration = 0

	# position.y = position.y + sin(Clock.time * 3.0) * 0.05

func _on_weapon_shake(strength: float, duration: float):
	shake_strength = strength
	shake_duration = duration
