shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap; //repeat_disable, filter_nearest;

uniform vec4 color: source_color = vec4(0.0, 0.0, 0.0, 0.2);

void fragment() {
	vec4 screen_color = texture(screen_texture, SCREEN_UV);
	vec4 sprite_color = texture(TEXTURE, UV);
	float color_diff = distance(sprite_color.rgb, screen_color.rgb);
	if (color_diff < 0.01) {
		COLOR = sprite_color;
	} else {
		vec4 silouette_color = vec4(color.rgb, color.a * sprite_color.a);
		COLOR = silouette_color;
	}
}
