class_name VendingMachine extends Node3D

@export var dialogue: DialogueResource

@export_category("face expressions")
@export var neutral_texture: Texture2D
@export var happy_texture: Texture2D
@export var blink_texture: Texture2D
@export var interact_texture: Texture2D

@onready var face: TextureRect = $SubViewport/Face
@onready var background: ColorRect = $SubViewport/Background

var is_in_range = false
var original_bg_color: Color
var status = "neutral"

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and is_in_range and not DialogueManager.is_active:
		DialogueManager.start_dialogue(dialogue)

func _ready() -> void:
	DialogueManager.dialogue_line_changed.connect(_on_dialogue_line_changed)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	original_bg_color = background.color

func _process(dt: float) -> void:
	face.position.y = sin(Clock.time * 3.0) * 5.0
	face.rotation_degrees = sin(Clock.time * 1.0) * 5.0

func set_status(new_status: String):
	status = new_status
	match status:
		"neutral": face.texture = neutral_texture
		"happy": face.texture = happy_texture
		"interact": face.texture = interact_texture
		_: face.texture = neutral_texture

	if status == "interact":
		background.color = Color.WHITE
	else:
		background.color = original_bg_color

func _on_dialogue_line_changed(line: DialogueLineResource):
	set_status(line.status)

func _on_dialogue_ended():
	await Clock.wait(1.0)
	set_status("neutral")

func _on_dialogue_area_body_entered(body: Node3D) -> void:
	if not body is Player: return
	is_in_range = true
	set_status("interact")

func _on_dialogue_area_body_exited(body: Node3D) -> void:
	if not body is Player: return
	DialogueManager.end_dialogue()
	is_in_range = false
	if status == "interact":
		set_status("neutral")

func _on_watch_area_body_entered(body: Node3D) -> void:
	if not body is Player: return

func _on_watch_area_body_exited(body: Node3D) -> void:
	if not body is Player: return

func _on_blink_timer_timeout() -> void:
	if not status == "neutral": return
	face.texture = blink_texture
	await Clock.wait(0.2)
	if not status == "neutral": return
	face.texture = neutral_texture
