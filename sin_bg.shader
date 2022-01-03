shader_type canvas_item;

void fragment() {	
	COLOR = texture(TEXTURE, vec2(UV.x + pow((float(0.5)-UV.y), 2) * sin(TIME) * float(0.5), UV.y));
}