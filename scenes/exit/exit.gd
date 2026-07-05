class_name Exit extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if not body is Player: return
	# Events.pixelate.emit(1.0)
	Events.fade_out.emit(0.25)
