shader_type canvas_item;

uniform float shake_power : hint_range(0.0, 0.1) = 0.03;
uniform float shake_speed : hint_range(0.0, 50.0) = 20.0;
uniform float color_separation : hint_range(0.0, 0.1) = 0.015;

// Continuous high-frequency noise
float noise(float s) {
    return fract(sin(s * 12.9898) * 43758.5453);
}

void fragment() {
    // 1. Create a constant jitter value that never hits zero
    // We use a high-frequency sine combined with noise
    float constant_noise = noise(trunc(TIME * shake_speed));

    // 2. Apply horizontal displacement per-row
    // Adding UV.y ensures different rows shift differently
    float shift = (noise(trunc(UV.y * 20.0) + TIME * shake_speed) - 0.5) * shake_power;

    vec2 fixed_uv = UV;
    fixed_uv.x += shift;

    // 3. Constant RGB Split
    // We sample R, G, and B at slightly different X-offsets constantly
    float r = texture(TEXTURE, vec2(fixed_uv.x + color_separation, fixed_uv.y)).r;
    float g = texture(TEXTURE, fixed_uv).g;
    float b = texture(TEXTURE, vec2(fixed_uv.x - color_separation, fixed_uv.y)).b;
    float a = texture(TEXTURE, fixed_uv).a;

    COLOR = vec4(r, g, b, a);
}