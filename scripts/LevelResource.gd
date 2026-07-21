class_name LevelResource extends Resource

@export var level_name = "level name"
@export var station_name = "L1"
@export_file("*.tscn", "*.scn") var level_scene_path: String
@export var ranking_cutoffs: Dictionary[String, float] = {
	"SS": 35,
	"S+": 45,
	"S": 60,
	"A": 90,
	"B": 120,
	"C": 150,
	"D": 0
}
