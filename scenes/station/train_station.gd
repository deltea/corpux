class_name TrainStation extends Node3D


const TRAIN_START_X = 500.0


@export var player: Player


@onready var train_anchor: Node3D = $TrainAnchor
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _physics_process(dt: float) -> void:
	animation_player.advance(dt)


func animate_train_enter() -> void:
	player.reparent(train_anchor)
	train_anchor.global_position.x = TRAIN_START_X
	# player.global_position.x = TRAIN_START_X
	player.position.x = 0
	# player.position.y = 10.0
	# await Clock.wait(5.0)
	animation_player.play("train_enter")
