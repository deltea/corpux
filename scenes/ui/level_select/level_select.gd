class_name LevelSelect extends CanvasLayer

const main_menu_scene = preload("res://scenes/ui/main_menu/main_menu.tscn")

const LINE_OFFSET = 300.0
const STATION_SEPARATION = 100.0

@export var station_scene: PackedScene
@export var levels: Dictionary[LevelResource, int] = {}

@onready var background: ColorRect = $Background
@onready var line: Line2D = $Line

var tween: Tween
var curr_selected = 0
var stations: Array[MetroStation]

func _ready() -> void:
	create_stations()
	animate_in()

	set_selected(curr_selected)

func animate_in():
	# background.position.y = -1080.0
	background.self_modulate.a = 0.0

	if tween: tween.kill()
	tween = create_tween().set_parallel().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(background, "self_modulate:a", 1.0, 0.5)
	# tween.tween_property(background, "position:y", 0.0, 0.5)

func create_stations():
	for level in levels:
		var station = station_scene.instantiate() as MetroStation
		line.add_child(station)
		stations.append(station)
		station.unselected.emit()
		station.set_info(level.station_name, level.level_name)
		station.global_position = line.get_point_position(levels.get(level))

func set_selected(value: int):
	stations[curr_selected].unselected.emit()
	curr_selected = clampi(value, 0, levels.size() - 1)
	stations[curr_selected].selected.emit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("down"):
		set_selected(curr_selected + 1)
	if event.is_action_pressed("up"):
		set_selected(curr_selected - 1)

func _on_buttons_button_pressed(id: String) -> void:
	if id == "back":
		get_tree().change_scene_to_file("res://rooms/main_menu.tscn")
	if id == "enter":
		get_tree().change_scene_to_packed(levels.keys()[curr_selected].level_scene)
