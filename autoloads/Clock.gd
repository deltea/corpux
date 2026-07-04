extends Node

var time = 0.0
var target_time_scale = 1.0
var is_hitstopping = false
var tween: Tween

func _ready() -> void:
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS

func _process(dt: float) -> void:
	var unscaled_dt = dt
	if Engine.time_scale > 0:
		unscaled_dt = dt / Engine.time_scale

	time += unscaled_dt
	# if not is_hitstopping:
	# 	Engine.time_scale = move_toward(Engine.time_scale, target_time_scale, 0.03)

func set_time_scale(value: float):
	Engine.time_scale = value

func hitstop(amount: float):
	is_hitstopping = true
	Engine.time_scale = 0.0
	await wait(amount)
	is_hitstopping = false
	Engine.time_scale = 1.0

func wait(duration: float):
	await get_tree().create_timer(duration, true, false, true).timeout

func time_stop(duration: float):
	Engine.time_scale = 0.0
	if tween: tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN).set_ignore_time_scale()
	tween.tween_property(Engine, "time_scale", 1.0, duration)
