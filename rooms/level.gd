class_name Level extends Room

var time = 0.0
var is_timer_started = false

func _ready() -> void:
	Events.fade_in.emit(0.5)
	Events.unpixelate.emit(1.0)

	Events.end_level.connect(_on_end_level)

	await Clock.wait(1.0)
	is_timer_started = true

func _process(dt: float) -> void:
	if is_timer_started:
		time += dt

func _on_end_level():
	print(time)
	is_timer_started = false
	Events.fade_out.emit(0.25)
