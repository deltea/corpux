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
}

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
