class_name Weapon extends Node3D

signal weapon_shake(strength: float, duration: float)

@export var fire_rate = 4.0

@onready var fire_timer: Timer = $FireTimer

var can_fire = true
var cam: Camera
var player: Player

func _ready() -> void:
	fire_timer.wait_time = 1.0 / fire_rate

func trigger_fire():
	if can_fire:
		fire()

func fire():
	fire_timer.start()
	can_fire = false

func secondary_fire():
	pass

func secondary_fire_released():
	pass

func _on_fire_timer_timeout() -> void:
	can_fire = true
