class_name Utils extends Node

static func format_time(time: float):
	var minutes: int = int(time) / 60
	var seconds: int = int(time) % 60
	var milliseconds: int = int((time - int(time)) * 1000)
	return "%02d:%02d.%03d" % [minutes, seconds, milliseconds]
