class_name Leaderboard extends CanvasLayer

const leaderboard_entry_scene: PackedScene = preload("res://scenes/ui/leaderboard/leaderboard_entry_container.tscn")


@export var leaderboard_name: String = "level_1"

@onready var entry_container: VBoxContainer = $Leaderboard/MarginContainer/ScrollContainer/EntryContainer


func _ready() -> void:
	load_leaderboard()


func load_leaderboard() -> void:
	for child in entry_container.get_children():
		child.queue_free()

	var loading_label: Label = Label.new()
	var label_settings = LabelSettings.new()
	label_settings.font_size = 72
	loading_label.text = "loading entries..."
	loading_label.label_settings = label_settings
	entry_container.add_child(loading_label)

	if not Talo.current_player:
		await Events.player_logged_in

	var options := Talo.leaderboards.GetEntriesOptions.new()
	options.page = 0

	var res := await Talo.leaderboards.get_entries(leaderboard_name, options)
	var entries := res.entries

	loading_label.queue_free()

	for i in range(entries.size()):
		var entry = entries[i]
		var entry_row = leaderboard_entry_scene.instantiate() as LeaderboardEntryContainer
		entry_container.add_child(entry_row)
		entry_row.set_info(
			i + 1,
			entry.player_alias.display_name,
			entry.score,
			entry.player_alias.id == Talo.current_alias.id
		)

	print("leaderboard entries loaded!")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		queue_free()
