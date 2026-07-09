shader_type canvas_item;

uniform float speed_x = 1.0;
uniform float speed_y = 1.0;

void fragment() {
	vec4 tex_color = texture(TEXTURE, vec2(UV.x - TIME * speed_x, UV.y - TIME * speed_y));
	COLOR = vec4(tex_color.rgb, COLOR.a);
}
