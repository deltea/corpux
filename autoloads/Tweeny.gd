extends Node

const DEFAULT_TRANS = Tween.TRANS_EXPO
const DEFAULT_EASE = Tween.EASE_OUT

func tween_property_blink(
	tween: Tween,
	object: Object,
	property: NodePath,
	start_val: Variant,
	final_val: Variant,
	duration: float,
	iterations: int = 10
):
	object.set_indexed(property, start_val)
	var counted_time = 0.0
	for i in range(iterations):
		var wait_time = duration * pow(0.5, i + 1)
		tween.chain().tween_interval(wait_time / 2)
		tween.chain().tween_property(object, property, start_val, 0.0)
		tween.chain().tween_interval(wait_time / 2)
		tween.chain().tween_property(object, property, final_val, 0.0)
		counted_time += wait_time * 2
	tween.tween_property(object, property, final_val, 0.0).set_delay(duration - counted_time)

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
