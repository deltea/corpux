extends CanvasLayer

const BASE_SMEAR = 1.0

@onready var crt: ColorRect = $CRT
@onready var blur: ColorRect = $Blur

func set_smear(amount: float):
	crt.material.set_shader_parameter("luma_smear_px", BASE_SMEAR + amount)

