class_name BasicEnemy extends Enemy

@onready var top: MeshInstance3D = $basic_enemy/Cylinder

var rand_offset = 0.0

func _ready() -> void:
	rand_offset = randf_range(0.0, 5.0)

func _process(dt: float) -> void:
	top.position.y = snappedf(sin(Clock.time * 5.0 + rand_offset) * 0.3, 0.3)
