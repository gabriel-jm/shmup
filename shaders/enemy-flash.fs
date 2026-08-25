#pragma language glsl3

uniform vec3 pink;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
  vec4 textureColor = Texel(tex, texture_coords);

  if (distance(textureColor, vec4(pink, 1.0)) < 0.1) {
    return textureColor;
  }

  if (textureColor.a < 0.1) {
    return textureColor;
  }

  if (textureColor.r > 0.9) {
    return vec4(pink, 1.0);
  }

  return vec4(0.9, 0.1, 0.15, 1.0);
}
