class_name MetroStation extends Control

@export var selected_color = Color.BLUE
@export var unselected_color = Color.GRAY

signal selected()
signal unselected()

@onready var background: NinePatchRect = $Background
@onready var label: RichTextLabel = $Background/StationName

var is_selected = false

func _ready() -> void:
	selected.connect(_on_selected)
	unselected.connect(_on_unselected)

func set_info(station_name: String, level_name: String):
	label.text = "[wave]%s[/wave]  %s" % [station_name, level_name]

func _on_selected():
	background.self_modulate = selected_color
	is_selected = true

func _on_unselected():
	background.self_modulate = unselected_color
	is_selected = false
