class_name BoomerangRevolver extends Area3D

var is_returning = false
var dir = Vector3.FORWARD
var player: Player

var speed = 15.0
var spin_speed = 3000.0

func _ready() -> void:
	# make sure its rotated correctly
	var tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_rotation:x", -PI/2, 0.5)
	tween.tween_property(self, "global_rotation:z", 0.0, 0.5)

func _process(dt: float) -> void:
	rotation_degrees.y += spin_speed * dt

func _physics_process(dt: float) -> void:
	var velocity = dir * speed * dt
	global_position += velocity

func throw(throw_dir: Vector3, player_ref: Player):
	dir = throw_dir.normalized()
	player = player_ref
