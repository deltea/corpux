class_name Level extends Room

@export var level_resource: LevelResource

@export var end_screen_scene: PackedScene
@export var death_screen_scene: PackedScene

var curr_time = 0.0
var is_timer_started = false
var is_secret_found = false

func _ready() -> void:
	Events.unpixelate.emit(1.0)

	Events.end_level.connect(_on_end_level)
	Events.death.connect(_on_death)
	Events.enemy_died.connect(_on_enemy_died)

	await Clock.wait(1.0)
	is_timer_started = true

func _process(dt: float) -> void:
	if is_timer_started:
		curr_time += dt

func _on_end_level():
	print(curr_time)
	is_timer_started = false
	GlobalCanvas.set_smear(0.0)

	var end_screen = end_screen_scene.instantiate() as EndScreen
	add_child(end_screen)
	var rank = get_rank(curr_time, level_resource.ranking_cutoffs)
	SaveManager.update_level_data(level_resource.level_name, curr_time, rank, is_secret_found)
	end_screen.set_info(
		level_resource.level_name,
		curr_time,
		rank,
		SaveManager.get_level_time(level_resource.level_name),
		SaveManager.get_level_secret(level_resource.level_name)
	)

	await Clock.wait(0.25)

func _on_death():
	GlobalCanvas.set_smear(0.0)
	var death_screen = death_screen_scene.instantiate() as DeathScreen
	add_child(death_screen)

func _on_enemy_died():
	if get_tree().get_node_count_in_group("enemies") <= 1:
		Events.all_enemies_dead.emit()

func get_rank(time: float, cutoffs: Dictionary[String, float]) -> String:
	for rank in cutoffs.keys():
		if time <= cutoffs[rank]:
			return rank
	return cutoffs.keys()[-1]
