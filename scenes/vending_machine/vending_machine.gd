class_name VendingMachine extends Node3D

@export var dialogue: DialogueResource

var is_in_range = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and is_in_range and not DialogueManager.is_active:
		DialogueManager.start_dialogue(dialogue, self)

func _on_dialogue_area_body_entered(body: Node3D) -> void:
	if not body is Player: return
	is_in_range = true

func _on_dialogue_area_body_exited(body: Node3D) -> void:
	if not body is Player: return
	DialogueManager.end_dialogue()
	is_in_range = false

func _on_watch_area_body_entered(body: Node3D) -> void:
	if not body is Player: return

func _on_watch_area_body_exited(body: Node3D) -> void:
	if not body is Player: return
