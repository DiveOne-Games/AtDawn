shader_type canvas_item;

uniform float fade : hint_range(0.0, 1.0);
uniform float offset : hint_range(0.0, 1.0);


void fragment() {
	// vec4 color = texture(TEXTURE, UV);
	// color.a *= clamp(1.0 - offset/fade, 0.0, 1.0);
	COLOR = texture(TEXTURE, UV);
	COLOR.a *= clamp(1.0 - offset/fade, 0.0, 1.0);
}
