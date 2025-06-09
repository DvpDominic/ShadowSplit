shader_type canvas_item;

render_mode unshaded, light_only; // ensures glow works and ignores scene lighting

uniform vec4 tint_color : source_color = vec4(1.0, 0.0, 1.0, 1.0); // Magenta

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    if (tex_color.a < 0.01) {
        discard;
    }

    float brightness = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));
    vec3 glow_color = tint_color.rgb * brightness;

    COLOR = vec4(glow_color, tex_color.a);
}