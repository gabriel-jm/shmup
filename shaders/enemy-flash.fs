#pragma language glsl3

uniform vec3 targetColor;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
  vec4 textureColor = Texel(tex, texture_coords);

  if (distance(textureColor, vec4(targetColor, 1.0)) < 0.1) {
    return vec4(1.0, 1.0, 1.0, 1.0);
  }

  return textureColor;
}
