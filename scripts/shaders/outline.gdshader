shader_type canvas_item;

uniform float outline_thickness: hint_range(1, 100, 0.1) = 8.0;
uniform float anti_alias_amount = 1.0;
uniform vec4 outline_color: source_color = vec4(1);
uniform float alpha_cutoff = 0.0;

void fragment() {
	float max_distance = outline_thickness + anti_alias_amount;
	int max_offset = int(ceil(max_distance));
	float closest_outline_distance = max_distance;
	
	for (int x = -max_offset; x <= max_offset; x++) {
		for (int y = -max_offset; y <= max_offset; y++) {
			vec2 offset = vec2(float(x), float(y));
			float dist = length(offset);
			
			if (dist > max_distance) continue;
			
			if (texture(TEXTURE, UV + offset * TEXTURE_PIXEL_SIZE).a > alpha_cutoff) {
				closest_outline_distance = min(closest_outline_distance, dist);
			}
		}
	}
	
	float alpha = 1.0 - smoothstep(outline_thickness - anti_alias_amount, outline_thickness + anti_alias_amount, closest_outline_distance);
	vec3 existing_color = COLOR.rgb * COLOR.a;
	vec3 new_color = outline_color.rgb * alpha * (1.0 - COLOR.a);
	COLOR = vec4(existing_color + new_color, alpha);
}
