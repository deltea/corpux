class_name HudLayer extends CanvasLayer

const CROSSHAIR_FIRE_WIDTH = 16.0
const CROSSHAIR_NORMAL_WIDTH = 14.0

@export var dash_texture: Texture2D
@export var enemy_crosshair_texture: Texture2D
@export var normal_crosshair_texture: Texture2D

@onready var dash_container: VBoxContainer = $DashContainerBackground/DashContainer
@onready var time_label: RichTextLabel = $TimeLabel
@onready var spinny: TextureRect = $Spinny
@onready var crosshair: NinePatchRect = $CrosshairContainer/Crosshair
@onready var crosshair_center: TextureRect = $CrosshairContainer/CrosshairCenter

var crosshair_tween: Tween
var crosshair_center_tween: Tween

func _ready() -> void:
	Events.player_dash_changed.connect(_on_dash_changed)
	Events.enemy_died.connect(_on_enemy_died)
	Events.fire.connect(_on_fire)

	var tween = create_tween().set_loops()
	tween.tween_property(spinny, "rotation", PI / 2, 0.5).as_relative()
	tween.tween_interval(0.5)

func _process(dt: float) -> void:
	time_label.text = "[shake]" + Utils.format_time(get_tree().current_scene.curr_time)

func _on_dash_changed(value: int):
	var child_count = dash_container.get_child_count()
	if value < child_count:
		for i in range(child_count - value):
			if dash_container.get_child_count() >= child_count - value:
				dash_container.get_child(i).queue_free()
	elif value > child_count:
		for i in range(value - child_count):
			create_dash_rect()

func create_dash_rect():
	var texture_rect = TextureRect.new()
	texture_rect.texture = dash_texture
	texture_rect.custom_minimum_size = Vector2(80, 0)
	texture_rect.custom_maximum_size = Vector2(-1, 40)
	dash_container.add_child(texture_rect)

func _on_enemy_died():
	crosshair_center.texture = enemy_crosshair_texture
	if crosshair_center_tween: crosshair_center_tween.kill()
	crosshair_center_tween = create_tween().set_ignore_time_scale()
	Tweeny.tween_property_blink(crosshair_center_tween, crosshair_center, "self_modulate:a", 0.0, 1.0, 0.5)
	crosshair_center_tween.chain().tween_callback(func():
		crosshair_center.self_modulate.a = 1.0
		crosshair_center.texture = normal_crosshair_texture
	).set_delay(0.5)

func _on_fire():
	if crosshair_tween: crosshair_tween.kill()
	crosshair_tween = create_tween().set_ignore_time_scale()
	crosshair_tween.tween_property(crosshair, "size:x", CROSSHAIR_FIRE_WIDTH, 0.0)
	crosshair_tween.tween_property(crosshair, "size:x", CROSSHAIR_NORMAL_WIDTH, 0.0).set_delay(0.2)
