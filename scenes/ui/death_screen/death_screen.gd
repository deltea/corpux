class_name DeathScreen extends CanvasLayer

@onready var dither: ColorRect = $DitherRect
@onready var death_label: RichTextLabel = $DeathLabel
@onready var instructions_label: RichTextLabel = $InstructionsLabel

func _ready() -> void:
	# death_label.visible_ratio = 0.0
	instructions_label.visible_ratio = 0.0

	var tween = create_tween().set_parallel().set_ignore_time_scale()
	# tween.tween_property(death_label, "visible_ratio", 1.0, 0.5)
	tween.tween_property(instructions_label, "visible_ratio", 1.0, 0.2)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
