local pico8Colors = require "pico8.colors"
local pico8Math = require "pico8.math"
local particles = require "particles.particle"

local explosionSfx --- @type love.Source

local function explosionCloud(x, y, toR, delay, lifespan, speed, onEnd, colors, drift)
  local parts = 6
  local angle = math.random()
  local step = 1 / parts

  for i = 1, parts do
    local distance = math.floor(4 + toR * 0.7)
    local halfDistance = distance / 2
    local currentAngle = angle + step * i

    particles.newParticle({
      x = x + pico8Math.sin(currentAngle) * halfDistance,
      y = y + pico8Math.cos(currentAngle) * halfDistance,
      sx = 0,
      sy = drift,
      toR = toR,
      delay = delay,
      lifespan = lifespan,
      toX = x + pico8Math.sin(currentAngle) * distance,
      toY = y + pico8Math.cos(currentAngle) * distance,
      onEnd = onEnd,
      speed = speed,
      colorTransition = colors
    })
  end

  particles.newParticle({
    x = x,
    y = y,
    sx = 0,
    sy = drift,
    toR = toR + 1,
    delay = delay,
    lifespan = lifespan,
    onEnd = onEnd,
    speed = speed,
    colorTransition = colors
  })
end

local function explode(x, y)
  explosionSfx:clone():play()

  particles.newParticle({
    x = x,
    y = y,
    r = 17,
    lifespan = 2,
    colors = {pico8Colors.yellow, pico8Colors.white}
  })

  explosionCloud(
    x, y, 5, 2, 15, 1, "return",
    {
      {pico8Colors.yellow, pico8Colors.white},
      {pico8Colors.orange, pico8Colors.yellow},
      {pico8Colors.yellow, pico8Colors.orange}
    },
    0
  )
  explosionCloud(
    x-math.random(2, 8), y-5, 6, 13, 18, 1, "return",
    {
      {pico8Colors.yellow, pico8Colors.white},
      {pico8Colors.orange, pico8Colors.yellow},
      {pico8Colors.yellow, pico8Colors.orange}
    },
    -0.2
  )
  explosionCloud(
    x+math.random(2, 8), y-10, 8, 18, 23, 0.8, "fade",
    {
      {pico8Colors.yellow, pico8Colors.white},
      {pico8Colors.yellow, pico8Colors.white},
      {pico8Colors.yellow, pico8Colors.orange},
      {pico8Colors.red, pico8Colors.darkGray},
      {pico8Colors.darkGray, pico8Colors.indigo}
    },
    -0.3
  )
end

local function load()
  explosionSfx = love.audio.newSource("assets/sfx/explosion.wav", "static")
end

local function update()
  particles.update()
end

function love:keypressed(key)
  if key == "x" then
    explode(64, 64)
  end
end

local function draw()
  love.graphics.clear(pico8Colors.blue)

  love.graphics.line(10, 10, 20, 20)

  particles.draw()
end

return {
  load = load,
  update = update,
  draw = draw
}
