class_name BaseWeapon extends Node3D

@export var fire_rate = 1.0

@onready var fire_timer: Timer = $FireTimer

var can_fire = true

func _ready() -> void:
	fire_timer.wait_time = 1.0 / fire_rate

func fire():
	fire_timer.start()
	can_fire = false

func _on_fire_timer_timeout() -> void:
	can_fire = true
