class_name LevelSelect extends CanvasLayer

@export var levels: Array[LevelResource] = []

@onready var background: ColorRect = $Background

var tween: Tween
var curr_selected = 0

func _ready() -> void:
	animate_in()

func animate_in():
	# background.position.y = -1080.0
	background.self_modulate.a = 0.0

	if tween: tween.kill()
	tween = create_tween().set_parallel().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(background, "self_modulate:a", 1.0, 0.5)
	# tween.tween_property(background, "position:y", 0.0, 0.5)

func set_selected(value: int):
	curr_selected = clampi(value, 0, levels.size() - 1)
