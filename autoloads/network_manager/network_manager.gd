extends CanvasLayer

@onready var username_edit: LineEdit = $UsernameContainer/UsernameEdit
@onready var username_container: Control = $UsernameContainer

func _ready() -> void:
	username_container.hide()

	# check if player is registering or logging in
	if SaveManager.get_player_username():
		login(SaveManager.get_player_username())
	else:
		register()

func register():
	username_container.show()
	username_edit.grab_focus()

func login(username: String) -> void:
	var player = await Talo.players.identify("username", username)

	if player:
		print("guest authenticated with id: ", player.id)
		Events.player_logged_in.emit()
	else:
		print("authentication failed!")

func submit_username():
	var username = username_edit.text.strip_edges()
	if await is_username_taken(username):
		print("username is taken!")
		return

	await login(username)
	SaveManager.set_player_username(username)
	username_container.hide()
	get_tree().reload_current_scene()

func is_username_taken(username: String) -> bool:
	var search_page = await Talo.players.search(username)
	return not search_page.count == 0

func _on_username_edit_text_submitted(_new_text: String) -> void:
	submit_username()

func submit_leaderboard_time(level_name: String, time: float) -> void:
	await Talo.leaderboards.add_entry("level_1", time)
