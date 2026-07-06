class_name EndScreen extends CanvasLayer

@onready var background: ColorRect = $Background
@onready var weapon_model: Node3D = $SubViewportContainer/SubViewport/weapon

func _ready() -> void:
	background.color.a = 0.0
	var tween = create_tween()
	tween.tween_property(background, "color:a", 1.0, 0.25)

func _process(dt: float) -> void:
	weapon_model.rotation_degrees.y += 50.0 * dt

func set_info():
	pass
