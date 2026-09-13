function math.clamp(num, min, max)
  return math.max(min, math.min(num, max))
end

function math.sign(num)
  if num > 0 then
    return 1
  end

  if num < 0 then
    return -1
  end

  return 0
end

function math.dist(x1, y1, x2, y2)
  local dx, dy = x2 - x1, y2 - y1

  return math.sqrt(dx * dx + dy * dy)
end
