class_name ButtonRow extends Control

signal button_pressed(id: String)

const button_scene = preload("res://scenes/ui/button_row/button.tscn")

@export var button_resources: Array[ButtonResource]
@export var spacing = 120.0
@export var is_column = false

@onready var selector: NinePatchRect = $Selector

var buttons: Array[Button] = []
var curr_selected = 0
var tween: Tween

func _ready() -> void:
	var width_sum = 0.0
	for i in range(button_resources.size()):
		var button_resource = button_resources[i]
		var button = button_scene.instantiate() as Button
		add_child(button)
		buttons.append(button)

		button.text = button_resource.label
		button.pressed.connect(button_pressed.emit.bind(button_resource.id))
		await get_tree().process_frame
		button.position.x = width_sum + (0.0 if i == 0 else spacing)
		width_sum += button.size.x

func change_selected(delta: int):
	curr_selected = wrapi(curr_selected + delta, 0, buttons.size())

	if tween: tween.kill()
	var target_pos = buttons[curr_selected].position - Vector2(24, 24)
	var target_size = buttons[curr_selected].size + Vector2(48, 48)
	tween = create_tween().set_parallel().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(selector, "position", target_pos, 0.25)
	tween.tween_property(selector, "size", target_size, 0.25)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left"):
		change_selected(-1)
	if event.is_action_pressed("right"):
		change_selected(1)
