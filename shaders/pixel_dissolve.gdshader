shader_type canvas_item;

float random(vec2 uv) {
	return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 438.5453);
}

uniform float dissolve_amount : hint_range(0.0, 1.0) = .5;
uniform vec4 background_color : source_color = vec4(1.0, 1.0, 1.0, 0.0);
uniform float scale_x = 1.0;
uniform float scale_y = 1.0;

varying vec4 modulate;

void vertex() {
	modulate = COLOR;
}

void fragment() {
	// Get size of texture in pixels
	float size_x = float(textureSize(TEXTURE, 0).x) * scale_x;
	float size_y = float(textureSize(TEXTURE, 0).y) * scale_y;
	// 
	vec4 pixelColor = texture(TEXTURE, UV);
	// Create a new "UV" which remaps every UV value to a snapped pixel value
	vec2 UVr = vec2(floor(UV.x*size_x)/size_x, floor(UV.y*size_y)/size_y);
	// Determine whether pixel should be visible or not
	float visible = step(dissolve_amount, random(UVr));
	// Draw the pixel, or not depending on if it is visible or not
	if (visible > 0.5) {
		COLOR = background_color;
	} else {
		COLOR = vec4(pixelColor.r, pixelColor.g, pixelColor.b, pixelColor.a) * modulate;
	}
}