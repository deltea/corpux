@tool
extends Node

const SAVE_PATH = "user://data.json"

@export_tool_button("Delete user data", "Remove") var delete_user_data_button = Callable(self, "delete_data")

var game_data = {

}

func _ready() -> void:
	load_data()

func save_data():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(game_data))

func load_data():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var json_string = file.get_as_text()
			var json = JSON.new()
			var result = json.parse(json_string)
			if result == OK:
				game_data = json.data
			else:
				print("json error: " + json.get_error_message())
	else:
		print("no data file exists")

func get_level_time(level_name: String):
	var base_path = "level_%s_" % level_name
	if game_data.has(base_path + "time"):
		return game_data[base_path + "time"]
	return null

func get_level_rank(level_name: String):
	var base_path = "level_%s_" % level_name
	if game_data.has(base_path + "rank"):
		return game_data[base_path + "rank"]
	return null

func get_level_secret(level_name: String):
	var base_path = "level_%s_" % level_name
	if game_data.has(base_path + "secret"):
		return game_data[base_path + "secret"]
	return null

func update_level_data(level_name: String, new_time: float, new_rank: String, new_secret: bool):
	var base_path = "level_%s_" % level_name
	if not game_data.has(base_path + "time") or new_time < float(game_data[base_path + "time"]):
		game_data[base_path + "time"] = new_time
		game_data[base_path + "rank"] = new_rank
		if not game_data.has(base_path + "secret") or not game_data[base_path + "secret"]:
			game_data[base_path + "secret"] = new_secret

		save_data()

func delete_data():
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
		print("save deleted")
	else:
		print("no save file to delete")
