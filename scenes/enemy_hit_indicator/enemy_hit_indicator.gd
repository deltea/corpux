class_name EnemyHitIndicator extends Sprite3D


func _ready() -> void:
	var tween := create_tween().set_parallel()
	# tween.tween_interval(0.5)
	tween.tween_property(self, "pixel_size", 0.005, 0.5).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	Tweeny.tween_property_blink(tween, self, "modulate:a", 1.0, 0.0, 0.5)
	tween.chain().tween_callback(queue_free)


func _process(dt: float) -> void:
	look_at(get_viewport().get_camera_3d().global_position)
