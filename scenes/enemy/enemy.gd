class_name Enemy extends StaticBody3D

@export var max_health = 2

var health = max_health

func take_damage(damage: int):
	print("oof")
	health -= damage
	if health <= 0:
		die()

func die():
	queue_free()
