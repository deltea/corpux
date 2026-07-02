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
	if face.texture == interact_texture:
		background.color = Color.WHITE
	else:
		background.color = original_bg_color

func _on_dialogue_line_changed(line: DialogueLineResource):
	match line.status:
		"neutral": face.texture = neutral_texture
		"happy": face.texture = happy_texture
		_: face.texture = neutral_texture

func _on_dialogue_ended():
	await Clock.wait(1.0)
	face.texture = neutral_texture

func _on_dialogue_area_body_entered(body: Node3D) -> void:
	if not body is Player: return
	is_in_range = true
	face.texture = interact_texture

func _on_dialogue_area_body_exited(body: Node3D) -> void:
	if not body is Player: return
	DialogueManager.end_dialogue()
	is_in_range = false
	if face.texture == interact_texture:
		face.texture = neutral_texture

func _on_watch_area_body_entered(body: Node3D) -> void:
	if not body is Player: return

func _on_watch_area_body_exited(body: Node3D) -> void:
	if not body is Player: return

func _on_blink_timer_timeout() -> void:
	if face.texture == neutral_texture:
		face.texture = blink_texture
		await Clock.wait(0.2)
		face.texture = neutral_texture
