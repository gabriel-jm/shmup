local function sin(value)
  local n = -math.sin(value * 2 * math.pi)

  if n < -1 or n > 1 or n == -0 then
    return 0
  end

  return n
end

local function cos(value)
  local n = -math.cos(value * 2 * math.pi)

  if n < -1 or n > 1 or n == -0 then
    return 0
  end

  return n
end

return {
  sin = sin,
  cos = cos
}
