local function sin(value)
  return -math.sin(value * 2 * math.pi)
end

local function cos(value)
  return -math.cos(value * 2 * math.pi)
end

return {
  sin = sin,
  cos = cos
}
