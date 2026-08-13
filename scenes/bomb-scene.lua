local pico8Colors = require "pico8.colors"
local particles = require "particles.particle"
local explosion = require "explosion.explosion"

local function load()
end

local function update()
  particles.update()
end

function love:keypressed(key)
  if key == "x" then
    explosion.explode(64, 64)
  end
end

local function draw()
  love.graphics.clear(pico8Colors.blue)

  particles.draw()
end

return {
  load = load,
  update = update,
  draw = draw
}
