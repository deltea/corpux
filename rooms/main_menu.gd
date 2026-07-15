class_name MainMenu extends Room

const level_select_scene = preload("res://scenes/ui/level_select/level_select.tscn")

@onready var version_label: Label = $VersionLabel
@onready var time_label: Label = $TimeLabel

func _ready() -> void:
	version_label.text = ProjectSettings.get_setting_with_override("application/config/version")

func _process(dt: float) -> void:
	time_label.text = Time.get_datetime_string_from_system()

func _on_button_row_button_pressed(id: String) -> void:
	if id == "start":
		# get_tree().change_scene_to_file("res://rooms/levels/tutorial_level.tscn")
		var level_select = level_select_scene.instantiate() as LevelSelect
		add_child(level_select)
	if id == "settings":
		print("there arent any settings bitch")
	if id == "quit":
		get_tree().quit()
