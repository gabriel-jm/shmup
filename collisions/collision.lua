local function checkCollision(a, b)
  local aLeft = a.x
  local aTop = a.y
  local aRight = a.x + a.colw - 1
  local aBottom = a.y +  a.colh - 1

  local bLeft = b.x
  local bTop = b.y
  local bRight = b.x + b.colw - 1
  local bBottom = b.y +  b.colh - 1

  if aTop > bBottom then return false end
  if bTop > aBottom then return false end
  if aLeft > bRight then return false end
  if bLeft > aRight then return false end

  return true
end

return {
  check = checkCollision
}
