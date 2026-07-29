shader_type canvas_item;

uniform float speed_x = 1.0;
uniform float speed_y = 1.0;
uniform float step = 0.25;

void fragment() {
	float t = round(TIME / step) * step;
	vec4 tex_color = texture(TEXTURE, vec2(UV.x - t * speed_x, UV.y - t * speed_y));
	COLOR = vec4(tex_color.rgb, COLOR.a);
}
