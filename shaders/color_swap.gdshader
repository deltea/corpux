shader_type canvas_item;

uniform vec4 color_a : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 color_b : source_color = vec4(0.0, 0.0, 1.0, 1.0);
uniform float threshold : hint_range(0.0, 1.0) = 0.05;
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest_mipmap;

void fragment() {
	vec4 screen_color = texture(screen_texture, SCREEN_UV);

	float dist_to_a = distance(screen_color.rgb, color_a.rgb);
	float dist_to_b = distance(screen_color.rgb, color_b.rgb);

	vec3 result_rgb = screen_color.rgb;

	if (dist_to_a <= threshold) {
		result_rgb = color_b.rgb;
	} else if (dist_to_b <= threshold) {
		result_rgb = color_a.rgb;
	}

	COLOR = vec4(result_rgb, screen_color.a);
}