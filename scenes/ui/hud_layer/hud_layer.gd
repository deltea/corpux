class_name HudLayer extends CanvasLayer

@export var dash_texture: Texture2D

@onready var dash_container: VBoxContainer = $DashContainerBackground/DashContainer
@onready var time_label: RichTextLabel = $TimeLabel

func _ready() -> void:
	Events.player_dash_changed.connect(_on_dash_changed)

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
