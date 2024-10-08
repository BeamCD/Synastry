shader_type canvas_item;
uniform float hue : hint_range(0.0, 6.283185) = 0.0;
uniform float saturation : hint_range(0.0, 1.0) = 1.0;
uniform float value : hint_range(0.0, 1.0) = 1.0;

void fragment()
{
    // Original Color
    COLOR = texture(TEXTURE,UV);
    vec3 color = COLOR.rgb;
    float alpha = COLOR.a;
    // Convert to YIQ space
    mat3 RGB_to_YIQ = mat3(
        vec3(0.2989,  0.5959,  0.2115),
        vec3(0.5870, -0.2774, -0.5229),
        vec3(0.1140, -0.3216,  0.3114)
    );
    color = RGB_to_YIQ * color;
    // Apply hue rotation
    float sin_hue = sin(hue);
    float cos_hue = cos(hue);
    mat3 hue_rotation = mat3(
        vec3(1.0,     0.0,      0.0),
        vec3(0.0, cos_hue, -sin_hue),
        vec3(0.0, sin_hue,  cos_hue)
    );
    color = hue_rotation * color;
    // Apply saturation
    mat3 saturation_scale = mat3(
        vec3(1.0,        0.0,         0.0),
        vec3(0.0, saturation,         0.0),
        vec3(0.0,        0.0,  saturation)
    );
    color = saturation_scale * color;
    // Apply value
    mat3 value_scale = mat3(
        vec3(value,   0.0,    0.0),
        vec3(  0.0, value,    0.0),
        vec3(  0.0,   0.0,  value)
    );
    color = value_scale * color;
    // Convert back to RGB space
    color = inverse(RGB_to_YIQ) * color;
    // Output
    COLOR = vec4(color, alpha);
}