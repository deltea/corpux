shader_type spatial;
render_mode unshaded, cull_disabled, depth_draw_never, blend_mix;


uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform float pixel_size : hint_range(1.0, 100.0, 1.0) = 10.0;

uniform int posterize : hint_range(0, 100, 1) = 20;
uniform vec3 color_A : source_color = vec3(0.5, 0.5, 0.0);
uniform vec3 color_B : source_color = vec3(0.1, 0.1, 0.1);

vec3 quntizarion_color(vec3 color) {
	color = floor(color * vec3(float(posterize))) / vec3(float(posterize));
	return color;
}


void fragment() {
    vec2 screen_res = vec2(textureSize(screen_texture, 0));
    vec2 block_size = pixel_size / screen_res;
    vec2 uv = floor(SCREEN_UV / block_size) * block_size;
    vec3 color = texture(screen_texture, uv).rgb;
    ALBEDO = color;
    ALPHA = 1.0;
}
