class_name ButtonRow extends Control

signal button_pressed(id: String)

const button_scene = preload("res://scenes/ui/button_row/button.tscn")

@export var button_resources: Array[ButtonResource]
@export var selector_spacing_x = 48.0
@export var selector_spacing_y = 48.0
@export var spacing = 120.0
@export var is_column = false

@onready var selector: NinePatchRect = $Selector

var buttons: Array[Button] = []
var curr_selected = 0
var tween: Tween

func _ready() -> void:
	var size_sum = 0.0
	for i in range(button_resources.size()):
		var button_resource = button_resources[i]
		var button = button_scene.instantiate() as Button
		add_child(button)
		buttons.append(button)

		button.text = button_resource.label
		button.pressed.connect(button_pressed.emit.bind(button_resource.id))
		button.mouse_entered.connect(func(): set_selected(i))

		await get_tree().process_frame
		if is_column:
			button.position.x = -button.size.x / 2
			button.position.y = size_sum
			size_sum += button.size.y + spacing
		else:
			button.position.x = size_sum
			size_sum += button.size.x + spacing

	set_selected(0)

func set_selected(value: int):
	curr_selected = clampi(value, 0, buttons.size() - 1)

	if tween: tween.kill()
	var target_pos = buttons[curr_selected].position - Vector2(selector_spacing_x / 2, selector_spacing_y / 2)
	var target_size = buttons[curr_selected].size + Vector2(selector_spacing_x, selector_spacing_y)
	tween = create_tween().set_parallel().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(selector, "position", target_pos, 0.25)
	tween.tween_property(selector, "size", target_size, 0.25)

func _input(event: InputEvent) -> void:
	var less = ("up" if is_column else "left")
	var more = ("down" if is_column else "right")
	if event.is_action_pressed(less):
		set_selected(curr_selected - 1)
	if event.is_action_pressed(more):
		set_selected(curr_selected + 1)
	if event.is_action_pressed("interact") or event.is_action_pressed("jump"):
		button_pressed.emit(button_resources[curr_selected].id)

func _on_selector_ping_timer_timeout() -> void:
	selector.scale = Vector2.ONE * 1.1
	var tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(selector, "scale", Vector2.ONE * 1.0, 0.4)
