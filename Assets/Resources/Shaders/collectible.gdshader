shader_type canvas_item;
render_mode blend_mix;

uniform float yellow_u = 1.0;
uniform float red = 0.9;

void fragment() {
  COLOR = texture(TEXTURE, UV);
  COLOR.y = yellow_u;
  COLOR.z = red;
}

