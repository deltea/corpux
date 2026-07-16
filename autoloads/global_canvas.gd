extends CanvasLayer

const BASE_SMEAR = 1.0

@onready var crt: ColorRect = $CRT
@onready var blur: ColorRect = $Blur
@onready var pixelate: ColorRect = $Pixelate
@onready var flashbang: ColorRect = $Flashbang

func _ready() -> void:
	Events.pixelate.connect(_on_pixelate)
	Events.unpixelate.connect(_on_unpixelate)
	Events.flashbang.connect(_on_flashbang)

func _on_pixelate(duration: float):
	pixelate.visible = true
	var tween = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.tween_property(pixelate.material, "shader_parameter/pixelSize", 1000, duration)
	tween.tween_callback(func(): pixelate.visible = false)

func _on_unpixelate(duration: float):
	pixelate.visible = true
	pixelate.material.set_shader_parameter("pixelSize", 1000)
	var tween = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.tween_property(pixelate.material, "shader_parameter/pixelSize", 1, duration)
	tween.tween_callback(func(): pixelate.visible = false)

func set_smear(amount: float):
	crt.material.set_shader_parameter("luma_smear_px", BASE_SMEAR + amount)

func _on_flashbang(duration: float, amount: float = 1.0):
	flashbang.color.a = amount
	var tween = create_tween()
	tween.tween_property(flashbang, "color:a", 0.0, duration)
