extends Node

const sounds = {}

func play_sound(sound_name: String):
	if not sounds.has(sound_name):
		push_error(sound_name + " is not a valid sound")
		return

	play_sound_from_stream(sounds[sound_name])

func play_sound_from_stream(stream: AudioStream):
	var player = AudioStreamPlayer.new()
	player.stream = stream
	player.bus = "SFX"
	player.finished.connect(player.queue_free)
	add_child(player)
	player.play()
