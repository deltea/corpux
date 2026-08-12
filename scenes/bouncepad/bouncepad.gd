class_name Bouncepad extends Area3D


const bounce_outer_scale = 1.25
const bounce_inner_scale = 1.2


@onready var outer: CSGMesh3D = $CSGCombiner3D/Outer
@onready var inner: CSGMesh3D = $CSGCombiner3D/Inner


var bounce_tween: Tween


func animate_bounce() -> void:
	if bounce_tween: bounce_tween.kill()
	bounce_tween = create_tween()
	# Tweeny.tween_property_snapped(bounce_tween, outer, "")
	bounce_tween.tween_property(outer, "scale", Vector3(bounce_outer_scale, 0, bounce_outer_scale), 0.6)
	bounce_tween.parallel().tween_property(inner, "scale", Vector3(bounce_inner_scale, 0, bounce_inner_scale), 0.2).set_delay(0.4)
	bounce_tween.tween_callback(func() -> void:
		outer.scale = Vector3.ONE
		inner.scale = Vector3.ONE
	)


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body.bounce()
		animate_bounce()
