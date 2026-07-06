shader_type canvas_item;

uniform vec4 solid_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	tex_color *= COLOR;
	if (tex_color.a > 0.0) {
        tex_color.rgb = solid_color.rgb;
    }
    COLOR = tex_color;
}