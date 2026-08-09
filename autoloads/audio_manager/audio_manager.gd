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
	"cyan-hardcore": preload("res://assets/audio/music/cyan hardcore.mp3"),
	"rigged-game": preload("res://assets/audio/music/rigged game.mp3"),

	"break": preload("res://assets/audio/music/Kick It Break.mp3"),
	"rainmaker": preload("res://assets/audio/music/Rainmaker.mp3"),
	"rave": preload("res://assets/audio/music/Ms.Rave & Mr.Bounce.mp3"),
	"touch": preload("res://assets/audio/music/touch.mp3"),
	"sweeet": preload("res://assets/audio/music/sweeet.mp3"),
	"around": preload("res://assets/audio/music/around.mp3"),
	"time": preload("res://assets/audio/music/time.mp3"),
	"honeymoon": preload("res://assets/audio/music/honeymoon.mp3"),
	"chrysalis": preload("res://assets/audio/music/chrysalis.mp3"),
	"eurolife": preload("res://assets/audio/music/eurolife.mp3"),
	"2000": preload("res://assets/audio/music/2000.mp3"),
	"jungle": preload("res://assets/audio/music/jungle.mp3"),
	"clarity": preload("res://assets/audio/music/clarity.mp3"),
}

@onready var music_player: AudioStreamPlayer = $MusicPlayer

var is_music_playing = false

func play_music(music_name: String):
	if not music.has(music_name):
		push_error(music_name + " is not a valid music track")
		return

	is_music_playing = true
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
