class_name DialogueBox extends Control

const TYPE_SPEED = 0.02
const CLOSED_Y_POS = 384.0

@onready var dither: TextureRect = $DitherTransition
@onready var background: ColorRect = $Background
@onready var label: RichTextLabel = $Text
@onready var arrow: TextureRect = $Arrow
@onready var speaker_label: RichTextLabel = $ColorRect/Speaker
@onready var speaker_background: ColorRect = $ColorRect

var is_typing = false
var curr_text: String
var tween: Tween

func _process(dt: float) -> void:
	arrow.visible = not is_typing
	arrow.position.x = 1792.0 + snappedf(sin(Clock.time * 5.0) * 5.0, 8.0)

func set_color(color: Color):
	dither.self_modulate = color
	background.color = color

func set_speaker(speaker: String):
	speaker_label.text = "[wave][b]%s[/b][/wave]" % speaker
	speaker_background.size.x = 40.0 * 2 + speaker_label.get_content_width()

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
	position.y = CLOSED_Y_POS
	t.tween_property(self, "position:y", 0.0, 0.5)
	await t.finished

func animate_close():
	var t = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	position.y = 0.0
	t.tween_property(self, "position:y", CLOSED_Y_POS, 0.5)
	await t.finished
