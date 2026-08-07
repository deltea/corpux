class_name DeathScreen extends CanvasLayer


# @onready var dither: ColorRect = $DitherRect
@onready var death_label: RichTextLabel = $DeathLabel
@onready var instructions_label: RichTextLabel = $InstructionsLabel
@onready var skull: TextureRect = $Skull


func _ready() -> void:
	death_label.visible_ratio = 0.0
	# instructions_label.visible_ratio = 0.0

	var tween := create_tween().set_parallel().set_ignore_time_scale()
	tween.tween_property(death_label, "visible_ratio", 1.0, 3.0)
	# tween.tween_property(instructions_label, "visible_ratio", 1.0, 0.5).set_delay(0.2)
	Tweeny.tween_property_blink(tween, instructions_label, "self_modulate:a", 0.0, 1.0, 0.75)

	tween = create_tween().set_ignore_time_scale()
	skull.material.set_shader_parameter("dissolve_amount", 0.0)
	# Tweeny.tween_property_blink(tween, skull, "self_modulate:a", 0.0, 1.0, 0.75)
	tween.tween_property(skull.material, "shader_parameter/dissolve_amount", 1.0, 0.5)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
