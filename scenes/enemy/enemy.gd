class_name Enemy extends StaticBody3D

@export var explosion_scene: PackedScene

@export var max_health = 2

var health: int

func _ready() -> void:
	health = max_health

func take_damage(damage: int):
	health -= damage
	if health <= 0:
		await die()
	else:
		Events.cam_shake.emit(0.01, 0.05)
		Clock.hitstop(0.08)

func die():
	queue_free()
	# await Clock.hitstop(0.15)
	Events.enemy_died.emit()

	var explosion = explosion_scene.instantiate() as GPUParticles3D
	explosion.position = global_position
	explosion.emitting = true
	get_tree().current_scene.add_child(explosion)
	Clock.time_stop(0.5)
