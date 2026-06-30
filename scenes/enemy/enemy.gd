class_name Enemy extends StaticBody3D

@export var max_health = 2

var health = max_health

func take_damage(damage: int):
	health -= damage
	if health <= 0:
		await die()
	else:
		Events.cam_shake.emit(0.01, 0.05)
		Clock.hitstop(0.08)

func die():
	queue_free()
	await Clock.hitstop(0.15)
	# Clock.set_time_scale(0.0)
