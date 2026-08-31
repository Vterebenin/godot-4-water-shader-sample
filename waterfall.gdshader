shader_type spatial;

render_mode blend_mix, specular_schlick_ggx, cull_disabled;

uniform vec4 light_color : source_color;
uniform vec4 dark_color : source_color;

uniform sampler2D water_tex : source_color;
uniform sampler2D noise_tex;
uniform sampler2D normal_tex : hint_normal;

uniform float displ_amount = 0.02;
uniform float speed = 1.0;

uniform vec2 strength = vec2(0.25, 0.5);
uniform vec2 frequency = vec2(3.0, 2.5);
uniform vec2 time_factor = vec2(5.0, 4.0);

float height(vec2 pos, float time) {
	return (strength.y * sin(pos.y * frequency.y + time * time_factor.y))
			+ (strength.x * sin(pos.x * frequency.x + time * time_factor.x));
}

void vertex() {
	VERTEX.y += height(VERTEX.yz, TIME);
}

void fragment() {
	vec2 displ = texture(water_tex, UV - TIME * speed / 8.0).xy;
	displ = (displ * 2.0 - 1.0) * displ_amount;

	float noise = texture(noise_tex, vec2(UV.x, UV.y / 4.0 - TIME * speed / 4.0) + displ).x;
	noise = floor(noise * 4.0) / 4.0;

	vec4 col = mix(dark_color, light_color, noise);

	vec2 uv_movement = UV;
	uv_movement -= vec2(0.0, 1.0) * TIME * speed;

	ALBEDO = col.rgb;
	NORMAL_MAP = texture(normal_tex, uv_movement).rgb;
	ROUGHNESS = 0.11;
	ALPHA = texture(water_tex, uv_movement).a * 0.75;
}
