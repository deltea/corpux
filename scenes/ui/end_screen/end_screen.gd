class_name EndScreen extends CanvasLayer

@onready var background: TextureRect = $Background
@onready var left_panel: Control = $LeftPanel
@onready var weapon_model: Node3D = $LeftPanel/WeaponContainer/SubViewport/weapon
@onready var success: ColorRect	= $LeftPanel/Success
@onready var level_name_label: RichTextLabel = $LeftPanel/LevelNameLabel
@onready var time_label: RichTextLabel = $LeftPanel/TimeLabel
@onready var best_label: RichTextLabel = $LeftPanel/BestLabel
@onready var secret_label: RichTextLabel = $LeftPanel/SecretLabel
@onready var weapon_container: SubViewportContainer = $LeftPanel/WeaponContainer
@onready var rank_label: RichTextLabel = $RankLabel
@onready var buttons: Control = $Buttons

func _ready() -> void:
	animate_in()

func _process(dt: float) -> void:
	weapon_model.rotation_degrees.y += 50.0 * dt

func set_info(
	level_name: String,
	time: float,
	desired_time: float,
	best_time: float,
	secret: bool
):
	level_name_label.text = "[wave freq=2 amp=100]" + level_name
	time_label.text = "TIME  //  " + str(format_time(time))
	best_label.text = "BEST  //  " + str(format_time(best_time))
	secret_label.text = "SECRET  //  " + ("yes" if secret else "no")
	rank_label.text = "[shake level=16 rate=40]" + get_rank(time, desired_time)
	# add weapon later

func get_rank(time: float, desired_time: float):
	return "S+"

func format_time(time: float) -> String:
	var minutes = int(time / 60)
	var seconds = int(time) % 60
	var hundredths = int((time - int(time)) * 100)

	return "%02d:%02d:%02d" % [minutes, seconds, hundredths]

func animate_in():
	background.self_modulate.a = 0.0
	left_panel.position.x = -1400
	success.position.x = -96
	rank_label.visible = false
	rank_label.scale = Vector2.ONE * 6.0

	level_name_label.visible_ratio = 0.0
	time_label.visible_ratio = 0.0
	best_label.visible_ratio = 0.0
	secret_label.visible_ratio = 0.0
	weapon_container.position.y = 1088.0
	buttons.position.y = 1120.0

	var tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT).set_parallel()
	tween.chain().tween_property(background, "self_modulate:a", 1.0, 0.5)
	tween.chain().tween_property(left_panel, "position:x", 0.0, 0.25)
	tween.chain().tween_property(success, "position:x", 0.0, 0.25)
	tween.tween_property(level_name_label, "visible_ratio", 1.0, 0.5).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(time_label, "visible_ratio", 1.0, 0.25).set_trans(Tween.TRANS_LINEAR).set_delay(0.1)
	tween.tween_property(best_label, "visible_ratio", 1.0, 0.25).set_trans(Tween.TRANS_LINEAR).set_delay(0.2)
	tween.tween_property(secret_label, "visible_ratio", 1.0, 0.25).set_trans(Tween.TRANS_LINEAR).set_delay(0.3)
	tween.tween_property(weapon_container, "position:y", 560.0, 0.4).set_delay(0.4)

	tween.chain().tween_callback(func(): rank_label.visible = true)
	tween.chain().tween_property(rank_label, "scale", Vector2.ONE * 1.0, 0.4).set_ease(Tween.EASE_IN)
	tween.chain().tween_callback(func(): Events.flashbang.emit(1.0))
	tween.chain().tween_property(buttons, "position:y", 840.0, 0.25).set_delay(0.4)
