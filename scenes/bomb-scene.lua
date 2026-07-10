local pico8Colors = require "pico8.colors"
local pico8Math = require "pico8.math"

local particles = {}

local function newParticle(props)
  local particle = {
    x = props.x,
    y = props.y,
    r = props.r or 2,
    originX = props.x,
    originY = props.y,
    delay = props.delay or nil,
    lifespan = props.lifespan or 30,
    maxLifespan = props.lifespan or 30,
    toX = props.toX or nil,
    toY = props.toY or nil,
    toR = props.toR or nil,
    speed = props.speed or 1,
    onEnd = props.onEnd or nil,
    colors = props.colors or {{pico8Colors.white, pico8Colors.white}}
  }

  function particle:update()
    if self.lifespan <= 0 then
      return
    end

    if self.delay then
      if self.delay <= 0 then
        self.delay = nil
      else
        self.delay = self.delay - 1
      end

      return
    end

    if self.toX and self.toY then
      self.x = self.x + (self.toX - self.x) / (4 / self.speed)
      self.y = self.y + (self.toY - self.y) / (4 / self.speed)
    end

    if self.toR then
      self.r = self.r + (self.toR - self.r) / (5 / self.speed)
    end

    self.lifespan = self.lifespan - 1
  end

  function particle:draw()
    if self.delay then
      return
    end

    local sx, sy, r = self.x, self.y, self.r
    local lifespanPercentage = 1 - self.lifespan / self.maxLifespan
    local colorIndex = math.floor(
      math.max(lifespanPercentage * (#self.colors + 1), 1)
    )
    local colors = self.colors[colorIndex]

    love.graphics.setColor(colors[1])
    love.graphics.circle("fill", sx, sy, math.max(r, 0))

    love.graphics.setColor(colors[2])
    love.graphics.circle("fill", sx, sy - 2, math.max(r - 2, 0))

    -- love.graphics.setColor(pico8Colors.white)
    -- love.graphics.circle("fill", sx, sy - 4, math.max(r - 4, 0))
  end

  function particle:ending(index)
    if self.onEnd == "return" then
      self.onEnd = nil
      self.lifespan = 10
      self.toR = 0

      return
    end

    if self.onEnd == "fade" then
      self.onEnd = nil
      self.lifespan = 10
      self.toR = 0
      self.speed = self.speed / 2

      return
    end

    table.remove(particles, index)
  end

  table.insert(particles, particle)
end

local function explosionCloud(x, y, toR, delay, lifespan, speed, onEnd, colors)
  local parts = 6
  local angle = math.random()
  local step = 1 / parts

  for i = 1, parts do
    local distance = math.floor(4 + toR * 0.7)
    local halfDistance = distance / 2
    local currentAngle = angle + step * i

    newParticle({
      x = x + pico8Math.sin(currentAngle) * halfDistance,
      y = y + pico8Math.cos(currentAngle) * halfDistance,
      toR = toR,
      delay = delay,
      lifespan = lifespan,
      toX = x + pico8Math.sin(currentAngle) * distance,
      toY = y + pico8Math.cos(currentAngle) * distance,
      onEnd = onEnd,
      speed = speed,
      colors = colors
    })
  end

  newParticle({
    x = x,
    y = y,
    toR = toR + 1,
    delay = delay,
    lifespan = lifespan,
    onEnd = onEnd,
    speed = speed,
    colors = colors
  })
end

local function explode(x, y)
  newParticle({
    x = x,
    y = y,
    r = 17,
    lifespan = 100,
    colors = {
      {pico8Colors.white, pico8Colors.white},
      {pico8Colors.orange, pico8Colors.yellow},
      {pico8Colors.yellow, pico8Colors.orange},
      {pico8Colors.darkGray, pico8Colors.red}
    }
  })

  -- explosionCloud(
  --   x, y, 6, 2, 13, 1, "return",
  --   {pico8Colors.orange, pico8Colors.yellow}
  -- )
  -- explosionCloud(
  --   x-math.random(5), y-5, 8, 12, 20, 1, "return",
  --   {pico8Colors.yellow, pico8Colors.orange}
  -- )
  -- explosionCloud(
  --   x+math.random(5), y-10, 10, 25, 25, 0.8, "fade",
  --   {pico8Colors.darkGray, pico8Colors.lightGray}
  -- )
end

local function load()
end

local function update()
  for i, p in pairs(particles) do
    p:update()

    if p.lifespan <= 0 or p.r < 0.5 then
      p:ending(i)
    end
  end
end

function love:keypressed(key)
  if key == "x" then
    explode(64, 64)
  end
end

local function draw()
  love.graphics.clear(pico8Colors.blue)

  for _, p in pairs(particles) do
    p:draw()
  end

  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print("#particles:"..#particles, 1, 1)
end

return {
  load = load,
  update = update,
  draw = draw
}
