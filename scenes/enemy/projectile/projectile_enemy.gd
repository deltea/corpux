class_name ProjectileEnemy extends Enemy

@export var projectile_scene: PackedScene

@onready var fire_point: Marker3D = $FirePoint

func fire():
	var projectile = projectile_scene.instantiate() as EnemyBullet
	get_tree().current_scene.add_child(projectile)
	projectile.position = fire_point.global_position
	var player = get_tree().get_first_node_in_group("player")
	projectile.dir = (player.global_position - fire_point.global_position).normalized()

func _on_fire_timer_timeout() -> void:
	fire()
