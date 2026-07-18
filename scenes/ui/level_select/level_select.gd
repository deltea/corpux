class_name LevelSelect extends CanvasLayer

const main_menu_scene = preload("res://scenes/ui/main_menu/main_menu.tscn")

const LINE_OFFSET = 800.0
const STATION_SEPARATION = 450.0
const STATION_SEPARATION_RANDOMNESS = 100.0

@export var station_scene: PackedScene
@export var levels: Array[LevelResource] = []

@onready var background: ColorRect = $Background
@onready var panel_background: ColorRect = $LeftBackground
@onready var line: Line2D = $Line
@onready var level_name_label: RichTextLabel = $LevelNameLabel
@onready var dither: TextureRect = $LeftBackground/DitherTransition
@onready var disc: Control = $Disc
@onready var button_row: ButtonRow = $ButtonRow
@onready var level_preview: TextureRect = $LevelPreview
@onready var rank_label: RichTextLabel = $RankLabel
@onready var best_label: RichTextLabel = $BestLabel
@onready var secret_label: RichTextLabel = $SecretLabel

var curr_selected = 0
var stations: Array[MetroStation]
var line_curve: Curve2D

var transition_tween: Tween
var line_tween: Tween

func _ready() -> void:
	line_curve = Curve2D.new()
	for p in line.points: line_curve.add_point(p)

	create_stations()
	animate_in()

	set_selected(curr_selected)

func animate_in():
	background.self_modulate.a = 0.0
	panel_background.position.x = -1096.0
	disc.position.y = -32.0
	line.position.x = 728.0
	button_row.position.y = 1136
	level_name_label.visible_ratio = 0.0
	level_preview.rotation_degrees = -90.0

	if transition_tween: transition_tween.kill()
	transition_tween = create_tween().set_parallel().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	transition_tween.tween_property(background, "self_modulate:a", 1.0, 0.8)
	transition_tween.tween_property(panel_background, "position:x", 0.0, 0.5)
	transition_tween.tween_property(disc, "position:y", 1072.0, 0.5)
	transition_tween.tween_property(line, "position:x", -80.0, 0.5).set_delay(0.25)
	transition_tween.tween_property(button_row, "position:y", 904.0, 0.5).set_delay(0.25)
	transition_tween.tween_property(level_name_label, "visible_ratio", 1.0, 0.5).set_delay(0.25).set_trans(Tween.TRANS_LINEAR)
	transition_tween.tween_property(level_preview, "rotation_degrees", 0.0, 0.5).set_delay(0.25)

func create_stations():
	for i in range(levels.size()):
		var level = levels[i]
		var station = station_scene.instantiate() as MetroStation
		line.add_child(station)
		stations.append(station)
		station.unselected.emit()
		station.set_info(level.station_name, level.level_name)
		var random_offset = randf_range(-STATION_SEPARATION_RANDOMNESS, STATION_SEPARATION_RANDOMNESS)
		var target_dist = i * STATION_SEPARATION + LINE_OFFSET + random_offset
		var baked_point = line_curve.sample_baked(target_dist)
		station.position = baked_point
		station.position.y -= station.size.y / 2

func set_selected(value: int):
	stations[curr_selected].unselected.emit()
	curr_selected = clampi(value, 0, levels.size() - 1)
	stations[curr_selected].selected.emit()

	var level_name = levels[curr_selected].level_name
	level_name_label.text = "[wave freq=2 amp=100]" + level_name
	if SaveManager.get_level_time(level_name):
		rank_label.text = "[shake level=20 rate=40]" + SaveManager.get_level_rank(level_name)
		best_label.text = "BEST  //  " + str(Utils.format_time(SaveManager.get_level_time(level_name)))
		secret_label.text = "SECRET  //  " + get_yes_no(SaveManager.get_level_secret(level_name))
	else:
		rank_label.text = "[shake level=20 rate=40]-  -"
		best_label.text = "BEST  //  ???"
		secret_label.text = "SECRET  //  ???"

	if line_tween: line_tween.kill()
	line_tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	var target_y = 540 - stations[curr_selected].global_position.y - stations[curr_selected].size.y / 2
	line_tween.tween_property(line, "global_position:y", target_y, 0.5).as_relative()

func get_yes_no(val: bool):
	return "yes" if val else "no"

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("down"):
		set_selected(curr_selected + 1)
	if event.is_action_pressed("up"):
		set_selected(curr_selected - 1)

func _on_buttons_button_pressed(id: String) -> void:
	if id == "back":
		get_tree().change_scene_to_file("res://rooms/main_menu.tscn")
	if id == "enter":
		get_tree().change_scene_to_file(levels[curr_selected].level_scene_path)
