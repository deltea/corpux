extends CanvasLayer

signal dialogue_started
signal dialogue_ended
signal dialogue_line_changed(line: DialogueLineResource)

@export var dialogue_box_scene: PackedScene

var dialogue_box: DialogueBox
var dialogue: DialogueResource
var curr_line = 0
var is_active = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and is_active:
		# if dialogue_box.is_typing:
		# 	dialogue_box.finish_typing()
		# else:
		# 	continue_dialogue()
		if not dialogue_box.is_typing:
			continue_dialogue()

func start_dialogue(dialogue_resource: DialogueResource):
	if is_active: return
	dialogue = dialogue_resource
	curr_line = 0
	dialogue_started.emit()

	dialogue_box = dialogue_box_scene.instantiate() as DialogueBox
	add_child(dialogue_box)
	dialogue_box.char_typed.connect(_on_char_typed)

	show_curr_line()
	is_active = true
	dialogue_box.animate_open()

func continue_dialogue():
	curr_line += 1
	if curr_line >= dialogue.lines.size():
		end_dialogue()
	else:
		show_curr_line()

func show_curr_line():
	var line = dialogue.lines[curr_line]
	dialogue_box.set_color(line.color)
	dialogue_box.set_speaker(line.speaker)
	dialogue_box.type_text(line.text)
	dialogue_line_changed.emit(line)

func end_dialogue():
	if not is_active: return

	dialogue_ended.emit()
	await dialogue_box.animate_close()
	is_active = false
	dialogue = null
	remove_child(dialogue_box)

func _on_char_typed(c: String):
	var line = dialogue.lines[curr_line]
	print(line.voice)
	AudioManager.play_sound_from_stream(line.voice["a"].stream)
