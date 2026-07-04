extends Node

const sounds = {}

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
