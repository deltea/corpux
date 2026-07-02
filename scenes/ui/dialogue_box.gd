class_name DialogueBox extends Control

const TYPE_SPEED = 0.02

@onready var dither: TextureRect = $DitherTransition
@onready var background: ColorRect = $Background
@onready var label: RichTextLabel = $Text

var is_typing = false
var curr_text: String
var tween: Tween

func set_color(color: Color):
	dither.self_modulate = color
	background.color = color

func type_text(text: String):
	is_typing = true
	curr_text = text
	label.text = text

	if tween: tween.kill()
	tween = create_tween()
	label.visible_characters = 0
	var length = text.length()
	tween.tween_property(label, "visible_characters", length, length * TYPE_SPEED)
	tween.tween_callback(func(): is_typing = false)

func finish_typing():
	is_typing = false
	if tween: tween.kill()
	label.text = curr_text

func clear():
	label.text = ""

func animate_open():
	var t = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	position.y = 320.0
	t.tween_property(self, "position:y", 0.0, 0.5)
	await t.finished
