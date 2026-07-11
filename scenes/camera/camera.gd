class_name Camera extends Camera3D

const SHAKE_DAMP_SPEED = 2.0

var shake_duration = 0
var shake_strength = 0
var original_pos = Vector2.ZERO
var original_fov: float

func _ready() -> void:
	original_pos = Vector2(h_offset, v_offset)
	original_fov = fov

	Events.cam_shake.connect(shake)
	DialogueManager.dialogue_started.connect(func(): change_fov(60.0))
	DialogueManager.dialogue_ended.connect(func(): change_fov(original_fov))

func _process(dt: float) -> void:
	h_offset = original_pos.x
	v_offset = original_pos.y
	if shake_duration > 0:
		h_offset += randf_range(0, PI*2) * shake_strength
		v_offset += randf_range(0, PI*2) * shake_strength
		shake_duration -= dt * SHAKE_DAMP_SPEED
	else:
		shake_duration = 0

func shake(strength: float, duration: float):
	shake_strength = strength
	shake_duration = duration

func change_fov(value: float):
	var tween = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "fov", value, 0.5)
