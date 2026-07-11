shader_type spatial;

// Texture and scale controls
uniform sampler2D noise_tex : hint_default_white;
uniform float noise_scale = 2.0;
uniform float warp_strength = 0.5;

// Animation and movement
uniform float speed = 1.0;
uniform vec2 direction = vec2(1.0, 0.5);

void vertex() {
	// Calculate animated UV coordinates based on vertex world position to keep it seamless
	vec2 uv = VERTEX.xz * noise_scale + (direction * TIME * speed);
	
	// Sample the noise texture (using the red channel)
	float noise_val = texture(noise_tex, uv).r;
	
	// Apply warp: offset the vertex position by the noise value along the mesh normals
	VERTEX += NORMAL * noise_val * warp_strength;
}