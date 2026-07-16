class_name Exit extends Area3D

@onready var door_left: Node3D = $DoorLeft
@onready var door_right: Node3D = $DoorRight

var is_enabled = false

func _ready() -> void:
	Events.all_enemies_dead.connect(_on_all_enemies_dead)

func open_doors():
	var tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT).set_parallel()
	tween.tween_property(door_left, "position:x", 11, 0.4)
	tween.tween_property(door_right, "position:x", -11, 0.4)

func close_doors():
	var tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT).set_parallel()
	tween.tween_property(door_left, "position:x", 4, 0.4)
	tween.tween_property(door_right, "position:x", -4, 0.4)

func _on_body_entered(body: Node3D) -> void:
	if not body is Player: return
	Events.end_level.emit()

func _on_door_open_area_body_entered(body: Node3D) -> void:
	if not body is Player or not is_enabled: return
	open_doors()

func _on_door_open_area_body_exited(body: Node3D) -> void:
	if not body is Player or not is_enabled: return
	close_doors()

func _on_all_enemies_dead():
	is_enabled = true
