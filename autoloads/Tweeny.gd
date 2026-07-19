extends Node

const DEFAULT_TRANS = Tween.TRANS_EXPO
const DEFAULT_EASE = Tween.EASE_OUT

func tween_property_snapped(
	tween: Tween,
	object: Object,
	property: NodePath,
	final_val: Variant,
	duration: float,
	snap_step: Variant
) -> MethodTweener:
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
