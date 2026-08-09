class_name TrainStation extends Node3D


const TRAIN_START_X = 1000.0


@export var player: Player


@onready var train_anchor: Node3D = $TrainAnchor


func _ready() -> void:
	train_anchor.position.x = TRAIN_START_X
	player.global_position.x = train_anchor.global_position.x
	# var tween := create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	# tween.tween_property(train_anchor, "global_position:x", 0.0, 10.0)
