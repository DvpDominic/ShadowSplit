shader_type canvas_item;

uniform bool flip = false; 

void fragment() {
    
    vec4 tex_color = texture(TEXTURE, UV);
    
    vec3 final_rgb = tex_color.rgb;
    
    if (flip) {
        final_rgb = 1.0 - tex_color.rgb;
    }
   
    COLOR = vec4(final_rgb, tex_color.a);
}