class_name MetroStation extends Control

@export var selected_color = Color.BLUE
@export var unselected_color = Color.GRAY

signal selected()
signal unselected()

@onready var background: NinePatchRect = $Background
@onready var label: RichTextLabel = $Background/StationName
@onready var dot: Panel = $Dot

var is_selected = false
var tween: Tween

func _ready() -> void:
	selected.connect(_on_selected)
	unselected.connect(_on_unselected)

func _process(dt: float) -> void:
	if is_selected:
		background.position.x = 56 + snapped(sin(6.0 * Clock.time) * 6.0, 10.0)

func set_info(station_name: String, level_name: String):
	label.text = "[wave]%s[/wave]  %s" % [station_name, level_name]

func _on_selected():
	background.self_modulate = selected_color
	is_selected = true
	dot.scale = Vector2.ONE * 2
	if tween: tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.tween_property(dot, "scale", Vector2.ONE, 0.5)

func _on_unselected():
	background.self_modulate = unselected_color
	is_selected = false
