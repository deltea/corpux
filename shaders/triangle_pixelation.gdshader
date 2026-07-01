shader_type canvas_item;

uniform vec2 pixel_grid_size = vec2(128.0);

group_uniforms Offsets;
uniform bool offset_x = false;
uniform bool offset_y = false;
uniform bool inverted = false;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

bool get_offset(vec2 uv) {
    vec2 grid_index = floor(uv * pixel_grid_size);
    float grid_total = dot(grid_index, vec2(float(offset_x), float(offset_y)));
    float offset_frequency = 2.0;
    bool is_offset = mod(grid_total, offset_frequency) < 1.0;
    is_offset = (is_offset != inverted);
    return is_offset;
}

vec2 get_triangle_center(vec2 uv, bool is_offset) {
    vec2 triangle_center;
    if (is_offset) {
        bool is_top_left = (uv.x + uv.y) <= 1.0;
        triangle_center = is_top_left ? vec2(1.0/3.0, 1.0/3.0) : vec2(2.0/3.0, 2.0/3.0);
    } else {
        bool is_top_right = (uv.x >= uv.y);
        triangle_center = is_top_right ? vec2(2.0/3.0, 1.0/3.0) : vec2(1.0/3.0, 2.0/3.0);
    }
    return triangle_center;
}

void fragment() {
    vec2 pixel_origin = floor(UV * pixel_grid_size) / pixel_grid_size;
    vec2 pixel_uv = fract(UV * pixel_grid_size);

    bool is_offset = get_offset(UV);
    vec2 triangle_center = get_triangle_center(pixel_uv, is_offset);
    vec2 triangle_uv = pixel_origin + (triangle_center / pixel_grid_size);

    COLOR = texture(screen_texture, triangle_uv);
}
