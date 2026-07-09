shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest_mipmap;
uniform int pixelSize = 4;

void fragment()
{

	ivec2 size = textureSize(screen_texture, 0);

	int xRes = size.x;
	int yRes = size.y;

	float xFactor = float(xRes) / float(pixelSize);
	float yFactor = float(yRes) / float(pixelSize);

	float grid_uv_x = round(SCREEN_UV.x * xFactor) / xFactor;
	float grid_uv_y = round(SCREEN_UV.y * yFactor) / yFactor;

	vec4 text = texture(screen_texture, vec2(grid_uv_x, grid_uv_y));

	COLOR = text;
}
