local function sin(value)
  return -math.sin(value * math.pi * 2)
end

local function cos(value)
  return math.cos(value * math.pi * 2)
end

return {
  sin = sin,
  cos = cos
}
