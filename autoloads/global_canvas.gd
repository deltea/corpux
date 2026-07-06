extends CanvasLayer

const BASE_SMEAR = 1.0

@onready var crt: ColorRect = $CRT
@onready var blur: ColorRect = $Blur
@onready var pixelate: ColorRect = $Pixelate

func _ready() -> void:
	Events.pixelate.connect(_on_pixelate)
	Events.unpixelate.connect(_on_unpixelate)

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

func set_smear(amount: float):
	crt.material.set_shader_parameter("luma_smear_px", BASE_SMEAR + amount)
