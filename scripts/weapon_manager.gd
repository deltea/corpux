class_name WeaponManager extends Node3D

const SHAKE_DAMP_SPEED = 2.0

@export var cam: Camera
@export var player: Player

@export_category("weapon scenes")
@export var revolver_scene: PackedScene

var equipped_weapon: Weapon
var shake_duration = 0.0
var shake_strength = 0.0
var original_pos: Vector3
var is_disabled = false
var tween: Tween

func _ready() -> void:
	original_pos = position

	DialogueManager.dialogue_started.connect(func(): disable_weapon())
	DialogueManager.dialogue_ended.connect(func(): enable_weapon())

	equip_weapon(revolver_scene)

func equip_weapon(weapon: PackedScene):
	equipped_weapon = weapon.instantiate() as Weapon
	add_child(equipped_weapon)
	equipped_weapon.cam = cam
	equipped_weapon.player = player
	equipped_weapon.weapon_shake.connect(_on_weapon_shake)

func unequip_weapon():
	equipped_weapon.queue_free()

func disable_weapon():
	if not equipped_weapon: return
	is_disabled = true

	if tween: tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", original_pos.y - 2.5, 0.5)
	tween.tween_callback(func(): hide())

func enable_weapon():
	if not equipped_weapon: return

	show()
	if tween: tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", original_pos.y, 0.5)
	tween.tween_callback(func(): is_disabled = false)

func _process(dt: float) -> void:
	if not equipped_weapon or is_disabled: return

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

	position.y = snappedf(position.y + sin(Clock.time * 4.0) * 0.08, 0.04)

func _on_weapon_shake(strength: float, duration: float):
	shake_strength = strength
	shake_duration = duration
