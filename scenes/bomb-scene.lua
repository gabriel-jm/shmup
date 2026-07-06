local pico8Colors = require "pico8.colors"

local x, y, r = 64, 64, 10

local function load()

end

local function update()
  if love.keyboard.isDown("up") then
    r = math.min(r + 1, 60)
  end

  if love.keyboard.isDown("down") then
    r = math.max(r - 1, 1)
  end
end

local function draw()
  love.graphics.clear(pico8Colors.blue)

  love.graphics.setColor(pico8Colors.darkPurple)
  love.graphics.circle("fill", x, y, r)

  love.graphics.setColor(pico8Colors.orange)
  love.graphics.circle("fill", x, y - 2, r - 2)

  love.graphics.setColor(pico8Colors.yellow)
  love.graphics.circle("fill", x, y - 4, r - 4)

  love.graphics.setColor(pico8Colors.white)
  love.graphics.circle("fill", x, y - 6, r - 6)

  love.graphics.setColor(pico8Colors.darkBlue)
  love.graphics.print(r, 60, 100)
end

return {
  load = load,
  update = update,
  draw = draw
}
