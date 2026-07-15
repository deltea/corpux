class_name LevelSelect extends CanvasLayer

const main_menu_scene = preload("res://scenes/ui/main_menu/main_menu.tscn")

const LINE_OFFSET = 800.0
const STATION_SEPARATION = 450.0
const STATION_SEPARATION_RANDOMNESS = 100.0

@export var station_scene: PackedScene
@export var levels: Array[LevelResource] = []

@onready var background: ColorRect = $Background
@onready var line: Line2D = $Line
@onready var level_name_label: RichTextLabel = $LevelNameLabel

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
	# background.position.y = -1080.0
	background.self_modulate.a = 0.0

	if transition_tween: transition_tween.kill()
	transition_tween = create_tween().set_parallel().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	transition_tween.tween_property(background, "self_modulate:a", 1.0, 0.5)
	# transition_tween.tween_property(background, "position:y", 0.0, 0.5)

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
	level_name_label.text = "[wave freq=2 amp=100]" + levels[curr_selected].level_name

	if line_tween: line_tween.kill()
	line_tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	var target_y = 540 - stations[curr_selected].global_position.y - stations[curr_selected].size.y / 2
	line_tween.tween_property(line, "global_position:y", target_y, 0.5).as_relative()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("down"):
		set_selected(curr_selected + 1)
	if event.is_action_pressed("up"):
		set_selected(curr_selected - 1)

func _on_buttons_button_pressed(id: String) -> void:
	if id == "back":
		get_tree().change_scene_to_file("res://rooms/main_menu.tscn")
	if id == "enter":
		get_tree().change_scene_to_packed(levels[curr_selected].level_scene)
