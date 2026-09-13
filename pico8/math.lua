local function sin(value)
  return -math.sin(value * math.pi * 2)
end

local function cos(value)
  return math.cos(value * math.pi * 2)
end

local function atan2(x, y)
  ---@diagnostic disable-next-line: redundant-parameter
  local deg = math.deg(math.atan2(-x, y)) % 360

  if deg >= 360 then
    return 0
  end

  local percent =  (deg / 360 * 100) / 100

  return percent
end

return {
  sin = sin,
  cos = cos,
  atan2 = atan2
}
