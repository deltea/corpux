extends Node

var time = 0.0
var target_time_scale = 1.0
var is_hitstopping = false

func _ready() -> void:
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS

func _process(dt: float) -> void:
	var unscaled_dt = dt
	if Engine.time_scale > 0:
		unscaled_dt = dt / Engine.time_scale

	time += unscaled_dt
	if not is_hitstopping:
		Engine.time_scale = lerp(Engine.time_scale, target_time_scale, 0.05)

func set_time_scale(value: float):
	Engine.time_scale = value

func hitstop(amount: float):
	is_hitstopping = true
	Engine.time_scale = 0.0
	await get_tree().create_timer(amount, true, false, true).timeout
	is_hitstopping = false
	Engine.time_scale = 1.0
