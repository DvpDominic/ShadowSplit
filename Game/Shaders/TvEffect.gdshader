shader_type canvas_item;

uniform float warp : hint_range(0.0, 1.0, 0.01) = 0.75;
uniform float scan : hint_range(0.0, 50.0, 0.1) = 0.75;
uniform float scan_speed : hint_range(0.0, 10.0, 0.1) = 2.0;
uniform float flicker_intensity : hint_range(0.0, 1.0, 0.01) = 0.1;
uniform float flicker_speed : hint_range(0.0, 20.0, 0.1) = 5.0;

// This uniform is crucial for sampling the screen behind the current CanvasItem.
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture; 

void fragment()
{
    // Get the normalized UV coordinates for the texture
    vec2 uv = UV; 
    vec2 fragPixelCoord = FRAGCOORD.xy;
    
    // Animate scanlines
    float animated_scan_y = fragPixelCoord.y + (TIME * scan_speed);
    
    // --- Sample the screen texture FIRST ---
    // Use SCREEN_UV to sample the SCREEN_TEXTURE, as SCREEN_UV is screen-space UVs (0-1)
    vec4 screen_color = texture(SCREEN_TEXTURE, SCREEN_UV);

    // squared distance from center (using the original UV for warping, if applied to a specific object)
    // If this shader is on a fullscreen ColorRect, you might want to use SCREEN_UV for 'uv' here too
    // For a CRT effect that applies to everything on screen, SCREEN_UV is likely better for 'uv'
    // Let's assume for a full screen CRT effect, you'd want to warp the screen itself.
    vec2 effect_uv = SCREEN_UV; // Use SCREEN_UV for warping the screen content
    
    vec2 dc = abs(0.5-effect_uv);
    dc *= dc;
    
    // warp the fragment coordinates
    effect_uv.x -= 0.5; effect_uv.x *= 1.0+(dc.y*(0.3*warp)); effect_uv.x += 0.5;
    effect_uv.y -= 0.5; effect_uv *= 1.0+(dc.x*(0.4*warp)); effect_uv.y += 0.5;

    // Initialize final_color with the warped screen content
    vec3 final_color = texture(SCREEN_TEXTURE, effect_uv).rgb;

    // sample inside boundaries, otherwise set to black
    // This check is now applied to the warped screen UVs
    if (effect_uv.y > 1.0 || effect_uv.x < 0.0 || effect_uv.x > 1.0 || effect_uv.y < 0.0)
    {
        final_color = vec3(0.0); // Set to black if outside bounds after warp
    }
    
    // Determine if we are drawing in a scanline
    float apply_scan = abs(sin(animated_scan_y * scan) * 0.5); 
    
    // Add a slight flicker effect based on time
    float flicker_amount = sin(TIME * flicker_speed) * 0.5 + 0.5; 
    flicker_amount = mix(1.0, flicker_amount, flicker_intensity); 

    // Mix with black for scanlines, then apply flicker
    final_color = mix(final_color, vec3(0.0), apply_scan);
    final_color *= flicker_amount; // Apply overall flicker

    COLOR = vec4(final_color, 1.0); // Output the final color with full opacity
}