class_name LevelResource extends Resource

@export var level_name = "level name"
@export var station_name = "L1"
@export_file("*.tscn", "*.scn") var level_scene_path: String
@export var ranking_cutoffs: Dictionary[String, float] = {
	"S+": 60,
	"S": 80,
	"A": 110,
	"B": 150,
	"C": 180,
	"D": 0
}
