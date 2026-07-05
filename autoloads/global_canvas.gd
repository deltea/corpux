extends CanvasLayer

const BASE_SMEAR = 1.0

@onready var crt: ColorRect = $CRT
@onready var blur: ColorRect = $Blur
@onready var pixelate: ColorRect = $Pixelate
@onready var cover: ColorRect = $Cover

func _ready() -> void:
	_on_unpixelate(1.0)
	_on_fade_in(0.5)

	Events.pixelate.connect(_on_pixelate)
	Events.unpixelate.connect(_on_unpixelate)
	Events.fade_out.connect(_on_fade_out)
	Events.fade_in.connect(_on_fade_in)

func _on_pixelate(duration: float):
	pixelate.visible = true
	var tween = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.tween_property(pixelate.material, "shader_parameter/pixelSize", 1000, duration)
	tween.tween_callback(func(): pixelate.visible = false)

func _on_unpixelate(duration: float):
	pixelate.visible = true
	var tween = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.tween_property(pixelate.material, "shader_parameter/pixelSize", 1, duration)
	tween.tween_callback(func(): pixelate.visible = false)

func _on_fade_out(duration: float):
	cover.color.a = 0.0
	var tween = create_tween()
	tween.tween_property(cover, "color:a", 1.0, duration)

func _on_fade_in(duration: float):
	cover.color.a = 1.0
	var tween = create_tween()
	tween.tween_property(cover, "color:a", 0.0, duration)

func set_smear(amount: float):
	crt.material.set_shader_parameter("luma_smear_px", BASE_SMEAR + amount)
