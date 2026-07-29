extends Node

const sounds = {
	"jump": preload("res://assets/audio/sfx/jump.wav"),
	"dash": preload("res://assets/audio/sfx/dash.wav"),
	"die": preload("res://assets/audio/sfx/die.wav"),
	"enemy-killed": preload("res://assets/audio/sfx/enemy-killed.wav"),
	"gunshot": preload("res://assets/audio/sfx/gunshot.wav"),
	"mission-complete": preload("res://assets/audio/sfx/mission-complete.wav"),
	"mission-failed": preload("res://assets/audio/sfx/mission-failed.wav"),
	"slam": preload("res://assets/audio/sfx/slam.wav"),
	"slamming": preload("res://assets/audio/sfx/slamming.wav"),

	"ui-select": preload("res://assets/audio/sfx/ui-select.wav"),
}

const music = {
	"kitsune": preload("res://assets/audio/music/kitsune.mp3"),
	"rayquaza": preload("res://assets/audio/music/rayquaza ex.mp3"),
	"fine-night": preload("res://assets/audio/music/fine night.mp3"),
}

@onready var music_player: AudioStreamPlayer = $MusicPlayer

func _ready() -> void:
	play_music(music.keys()[randi() % music.size()])

func play_music(music_name: String):
	if not music.has(music_name):
		push_error(music_name + " is not a valid music track")
		return

	music_player.stream = music[music_name]
	music_player.play()

func play_sound(sound_name: String, pitch: float = 1.0):
	if not sounds.has(sound_name):
		push_error(sound_name + " is not a valid sound")
		return

	play_sound_from_stream(sounds[sound_name], pitch)

func play_sound_from_stream(stream: AudioStream, pitch: float = 1.0):
	var player = AudioStreamPlayer.new()
	player.pitch_scale = pitch
	player.stream = stream
	player.bus = "SFX"
	player.finished.connect(player.queue_free)
	add_child(player)
	player.play()
