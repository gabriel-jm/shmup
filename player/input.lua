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
  1, -- stop
  2, -- code: 1 = left
  3, -- code: 2 = right
  1, -- code: 3 (L+R) = stop
  4, -- code: 4 (up) = down
  6, -- code: 5 (L+U) = left + up
  7, -- code: 6 (R+U) = right + up
  4, -- code: 7 (L+U+R) = up
  5, -- code: 8 (down) = down
  9, -- code: 9 (L+D) = left + down
  8, -- code: 10 (R+D) = right + down
  5, -- code: 11 (L+D+R) = down
  1, -- code: 12 (U+D) = stop
  2, -- code: 13 (L+U+D) = left
  3, -- code: 14 (R+U+D) = right
  1  -- code: 15 (L+D+R+U) = stop
}

local function inputCode()
  local code = 1

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
