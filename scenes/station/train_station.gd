class_name TrainStation extends Node3D


const skyhole_scene := preload("res://scenes/environment/skyhole.tscn")


const TRAIN_START_X = 500.0


@export var player: Player


@onready var train_anchor: Node3D = $TrainAnchor
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var combiner: CSGCombiner3D = $CSGCombiner3D


func _ready() -> void:
	var hole_count := 10
	var hole_sep := (1100.0 / 2 - 48.0) / hole_count
	for i in range(hole_count):
		var skyhole := skyhole_scene.instantiate() as CSGBox3D
		skyhole.position = Vector3(i * hole_sep, 10.0, 12.0)
		# skyhole.scale.x = 0.5
		# skyhole.scale.y = 0.5
		combiner.add_child(skyhole)


func _physics_process(dt: float) -> void:
	animation_player.advance(dt)


func animate_train_enter() -> void:
	player.reparent(train_anchor)
	train_anchor.global_position.x = TRAIN_START_X
	player.position.x = 0
	animation_player.play("train_enter")


func _on_train_area_body_exited(body: Node3D) -> void:
	if body is Player:
		Events.level_start.emit()
