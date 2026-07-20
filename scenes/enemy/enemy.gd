class_name Enemy extends StaticBody3D

@export var explosion_scene: PackedScene

@export var max_health = 2

@onready var marker: Sprite3D = $Marker

var health: int

func _ready() -> void:
	health = max_health

func take_damage(damage: int):
	health -= damage
	if health <= 0:
		await die()
	else:
		Events.cam_shake.emit(0.01, 0.05)
		Clock.hitstop(0.1)

func die():
	queue_free()
	Events.enemy_died.emit()
	Events.add_dash.emit()

	var explosion = explosion_scene.instantiate() as GPUParticles3D
	explosion.position = global_position
	explosion.emitting = true
	explosion.finished.connect(explosion.queue_free)
	get_tree().current_scene.add_child(explosion)
	Clock.time_stop(0.25)
	Events.flashbang.emit(0.1, 0.5)

func _on_auto_aim_area_aim_entered() -> void:
	marker.visible = true

func _on_auto_aim_area_aim_exited() -> void:
	marker.visible = false
