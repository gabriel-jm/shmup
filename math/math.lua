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
