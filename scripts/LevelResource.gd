class_name LevelResource extends Resource

enum Rank { S_PLUS, S, A, B, C, D }

@export var level_name = "Level Name"
@export var level_scene: PackedScene
@export var ranking_cutoffs: Dictionary[Rank, float] = {
	Rank.S_PLUS: 60,
	Rank.S: 90,
	Rank.A: 120,
	Rank.B: 150,
	Rank.C: 180
}
