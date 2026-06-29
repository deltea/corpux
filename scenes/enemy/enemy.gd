class_name Enemy extends StaticBody3D

@export var max_health = 2

var health = max_health

func take_damage(damage: int):
	print("oof")
	health -= damage
	if health <= 0:
		# Clock.hitstop(0.1)
		Clock.set_time_scale(0.0)
		die()
	else:
		Clock.hitstop(0.1)

func die():
	queue_free()
