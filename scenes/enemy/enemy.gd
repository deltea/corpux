class_name Enemy extends StaticBody3D

@export var max_health = 2

var health = max_health

func take_damage(damage: int):
	print("oof")
	health -= damage
	if health <= 0:
		await die()
	else:
		Clock.hitstop(0.08)

func die():
	await Clock.hitstop(0.15)
	Clock.set_time_scale(0.0)
	queue_free()
