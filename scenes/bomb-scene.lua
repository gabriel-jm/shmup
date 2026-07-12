local pico8Colors = require "pico8.colors"
local pico8Math = require "pico8.math"
local particles = require "particles.particle"
local newBlob = require "particles.blob"
local newSpark = require "particles.spark"

local explosionSfx --- @type love.Source

local function explosionCloud(x, y, delay, lifespan, speed, onEnd, colors, drift)
  local parts = 6
  local angle = math.random()
  local step = 1 / parts

  for i = 1, parts do
    local distance = 5 + math.random(5)
    local halfDistance = distance / 2
    local currentAngle = angle + step * i

    newBlob({
      x = x + pico8Math.sin(currentAngle) * halfDistance,
      y = y + pico8Math.cos(currentAngle) * halfDistance,
      sx = 0,
      sy = drift,
      toR = math.random(5, 8),
      delay = delay,
      lifespan = lifespan,
      toX = x + pico8Math.sin(currentAngle) * distance,
      toY = y + pico8Math.cos(currentAngle) * distance,
      onEnd = onEnd,
      speed = speed,
      colorTransition = colors,
      colorVariation = math.random(5)
    })
  end

  newBlob({
    x = x,
    y = y,
    sx = 0,
    sy = drift,
    toR = math.random(5, 8),
    delay = delay,
    lifespan = lifespan,
    onEnd = onEnd,
    speed = speed,
    colorTransition = colors
  })
end

local function sparkBlast(props)
  local baseAngle = math.random()

  for _=1, 6 do
    local angle = baseAngle + (math.random(50)/100)
    local speed = math.random(4, 8)

    newSpark({
      x = props.x,
      y = props.y,
      sx = pico8Math.sin(angle) * speed,
      sy = pico8Math.cos(angle) * speed,
      drag = 0.8,
      lifespan = math.random(8, 13),
      delay = props.delay,
      color = pico8Colors.yellow,
    })
  end
end

local function explode(x, y)
  explosionSfx:clone():play()

  newBlob({
    x = x,
    y = y,
    r = 17,
    lifespan = 2,
    colors = {pico8Colors.white, pico8Colors.white}
  })

  sparkBlast({ x = x, y = y, delay = 2 })
  sparkBlast({ x = x, y = y, delay = 8 })

  explosionCloud(
    x, y, 2, 15, 1, "return",
    {
      {pico8Colors.yellow, pico8Colors.white},
      {pico8Colors.orange, pico8Colors.yellow},
      {pico8Colors.yellow, pico8Colors.orange}
    },
    0
  )
  explosionCloud(
    x-math.random(2, 8), y-5, 13, 18, 1, "return",
    {
      {pico8Colors.yellow, pico8Colors.white},
      {pico8Colors.orange, pico8Colors.yellow},
      {pico8Colors.yellow, pico8Colors.orange}
    },
    -0.2
  )
  explosionCloud(
    x+math.random(2, 8), y-10, 20, 25, 0.8, "fade",
    {
      {pico8Colors.yellow, pico8Colors.white},
      {pico8Colors.yellow, pico8Colors.orange},
      {pico8Colors.orange, pico8Colors.darkGray},
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

  particles.draw()
end

return {
  load = load,
  update = update,
  draw = draw
}
