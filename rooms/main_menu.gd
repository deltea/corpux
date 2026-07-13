class_name MainMenu extends Room

func _on_button_row_button_pressed(id: String) -> void:
	if id == "start":
		get_tree().change_scene_to_file("res://rooms/levels/tutorial_level.tscn")
	if id == "settings":
		print("there arent any settings bitch")
	if id == "quit":
		get_tree().quit()
