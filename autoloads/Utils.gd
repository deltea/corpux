class_name Utils extends Node

static func format_time(time: float):
	var minutes: int = int(time) / 60
	var seconds: int = int(time) % 60
	var milliseconds: int = int((time - int(time)) * 1000)
	return "%02d:%02d.%03d" % [minutes, seconds, milliseconds]

static func tween_property_snapped(tween: Tween, object: Object, property: NodePath, final_val: Variant, duration: float, snap_step: Variant) -> MethodTweener:
	var start_val: Variant = object.get_indexed(property)
	var tweener := tween.tween_method(
		func(current_val: Variant):
			var snapped_val: Variant

			if current_val is Vector2:
				snapped_val = current_val.snapped(snap_step)
			elif current_val is Vector3:
				snapped_val = current_val.snapped(snap_step)
			else:
				snapped_val = snapped(current_val, snap_step)

			object.set_indexed(property, snapped_val),
		start_val,
		final_val,
		duration
	)

	return tweener

