shader_type canvas_item;

uniform int flip : hint_range(0, 1) = 0; 
uniform sampler2D screen_texture : hint_screen_texture;

void fragment(){
	vec4 screen_color = texture(screen_texture, SCREEN_UV);
	
	vec3 final_rgb = screen_color.rgb;
	
	if(flip == 1){
		final_rgb = 1.0 - screen_color.rgb;
	}
	
	COLOR = vec4(final_rgb, screen_color.a);
}
