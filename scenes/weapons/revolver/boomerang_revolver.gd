class_name BoomerangRevolver extends Node3D

const FLOOR_FLOAT_HEIGHT = 0.5
const MAX_SPEED = 120.0
const MAX_SPIN_SPEED = 2000.0
const MAX_DISTANCE = 48.0
const DECELERATION = 250.0
const RETURN_ACCELERATION = 120.0

var is_returning = false
var is_caught = false
var is_slowing = false
var is_bounce_back = false
var dir = Vector3.FORWARD
var home: Node3D
var distance_travelled = 0.0

var speed = 0.0
var target_distance = 0.0
var spin_speed = 0.0

var original_rot: Vector3
var original_pos: Vector3

signal caught()

func _ready() -> void:
	# make sure its rotated correctly
	var tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT).set_parallel()
	tween.tween_property(self, "global_rotation:x", -PI/2, 0.5)
	tween.tween_property(self, "global_rotation:z", 0.0, 0.5)

func come_back():
	is_returning = true

func _process(dt: float) -> void:
	if is_caught: return
	var spin_dir = (-1 if is_bounce_back else 1)
	rotation_degrees.y += spin_speed * spin_dir * dt

func _physics_process(dt: float) -> void:
	if is_caught: return
	if is_returning:
		speed += RETURN_ACCELERATION * dt
		var target_pos = home.global_position
		var to_target = global_position.direction_to(target_pos)

		global_position += to_target * speed * dt

		if global_position.distance_to(target_pos) < 1.0:
			catch()
	else:
		var velocity = dir * speed * dt
		global_position += velocity
		distance_travelled += velocity.length()

		if distance_travelled >= target_distance:
			is_slowing = true
		if is_slowing:
			speed = max(speed - DECELERATION * dt, 0.0)
			if speed <= 0.0:
				is_returning = true

	global_position.y = max(global_position.y, FLOOR_FLOAT_HEIGHT)

func catch():
	is_caught = true
	speed = 0.0
	spin_speed = 0.0
	caught.emit()
	queue_free()

## throw_force is a value from 0 to 1
func throw(throw_dir: Vector3, throw_force: float, return_node: Node3D):
	original_rot = global_rotation
	original_pos = global_position

	dir = throw_dir.normalized()
	home = return_node

	speed = MAX_SPEED
	target_distance = throw_force * MAX_DISTANCE
	spin_speed = MAX_SPIN_SPEED

func _on_hit_area_body_entered(body: Node3D) -> void:
	if body is Enemy:
		body.take_damage(2.0)
		# is_returning = true
		# is_bounce_back = true

func _on_bounce_back_area_body_entered(body: Node3D) -> void:
	if not body is Enemy and not body is Player:
		is_returning = true
		is_bounce_back = true
