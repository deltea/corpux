class_name Level extends Room


@export var level_resource: LevelResource

@export var end_screen_scene: PackedScene
@export var death_screen_scene: PackedScene


@onready var station: TrainStation = $EntranceStation


var curr_time := 0.0
var is_timer_started := false
var is_secret_found := false


func _ready() -> void:
	Events.unpixelate.emit(1.0)

	Events.end_level.connect(_on_end_level)
	Events.death.connect(_on_death)
	Events.enemy_died.connect(_on_enemy_died)
	Events.level_start.connect(_on_level_start)

	# await Clock.wait(2.0)
	station.animate_train_enter()


func _process(dt: float) -> void:
	if is_timer_started:
		curr_time += dt


func _on_end_level() -> void:
	is_timer_started = false
	GlobalCanvas.set_smear(0.0)

	var end_screen := end_screen_scene.instantiate() as EndScreen
	add_child(end_screen)
	var rank := Utils.get_rank(curr_time, level_resource.ranking_cutoffs)
	SaveManager.update_level_data(level_resource.level_name, curr_time, rank, is_secret_found)
	NetworkManager.submit_leaderboard_time(level_resource.level_name, curr_time)
	end_screen.set_info(
		level_resource.level_name,
		curr_time,
		rank,
		SaveManager.get_level_time(level_resource.level_name),
		SaveManager.get_level_secret(level_resource.level_name)
	)

	await Clock.wait(0.25)


func _on_death() -> void:
	GlobalCanvas.set_smear(0.0)
	var death_screen := death_screen_scene.instantiate() as DeathScreen
	add_child(death_screen)
	AudioManager.stop_music()


func _on_enemy_died() -> void:
	AudioManager.play_sound("enemy-killed")
	if get_tree().get_node_count_in_group("enemies") <= 1:
		Events.mission_complete.emit()
		await Clock.wait(0.5)
		AudioManager.play_sound("mission-complete")


func _on_level_start() -> void:
	if is_timer_started:
		return
	is_timer_started = true
	AudioManager.play_music("rigged-game")
