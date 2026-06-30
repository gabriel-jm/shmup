--[[
  1- left
  2- right
  3- up
  4- down

  5- left + up
  6- right + up
  7- right + down
  8- left + down
]]

local normalizedCodes = {
  1, -- code: 1 = left
  2, -- code: 2 = right
  0, -- code: 3 (L+R) = stop
  3, -- code: 4 (up) = down
  5, -- code: 5 (L+U) = left + up
  6, -- code: 6 (R+U) = right + up
  3, -- code: 7 (L+U+R) = up
  4, -- code: 8 (down) = down
  8, -- code: 9 (L+D) = left + down
  7, -- code: 10 (R+D) = right + down
  4, -- code: 11 (L+D+R) = down
  0, -- code: 12 (U+D) = stop
  1, -- code: 13 (L+U+D) = left
  2, -- code: 14 (R+U+D) = right
  0  -- code: 15 (L+D+R+U) = stop
}
normalizedCodes[0] = 0 -- for the stop

local function inputCode()
  local code = 0

  if love.keyboard.isDown("up") then
    code = code + 4
  end

  if love.keyboard.isDown("down") then
    code = code + 8
  end

  if love.keyboard.isDown("left") then
    code = code + 1
  end

  if love.keyboard.isDown("right") then
    code = code + 2
  end

  return normalizedCodes[code]
end

return inputCode
