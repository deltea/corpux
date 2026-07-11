class_name Level extends Room

@export var end_screen_scene: PackedScene
@export var death_screen_scene: PackedScene

var time = 0.0
var is_timer_started = false

func _ready() -> void:
	Events.unpixelate.emit(1.0)

	Events.end_level.connect(_on_end_level)
	Events.death.connect(_on_death)

	await Clock.wait(1.0)
	is_timer_started = true

func _process(dt: float) -> void:
	if is_timer_started:
		time += dt

func _on_end_level():
	print(time)
	is_timer_started = false

	var end_screen = end_screen_scene.instantiate() as EndScreen
	add_child(end_screen)
	end_screen.set_info("tutorial", time, 10.0, time, false)

	await Clock.wait(0.25)

func _on_death():
	var death_screen = death_screen_scene.instantiate() as DeathScreen
	add_child(death_screen)
