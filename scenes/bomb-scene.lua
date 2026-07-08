local pico8Colors = require "pico8.colors"
local pico8Math = require "pico8.math"

local particles = {}

local function newParticle(props)
  local particle = {
    x = props.x,
    y = props.y,
    r = props.r or 2,
    delay = props.delay or nil,
    lifespan = props.lifespan or 30,
    type = props.type or "grow"
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

    self.lifespan = self.lifespan - 1

    if self.type == "grow" then
      self.r = self.r + 1
    end
  end

  function particle:draw()
    if self.delay then
      return
    end

    local sx, sy, r = self.x, self.y, self.r

    love.graphics.setColor(pico8Colors.orange)
    love.graphics.circle("fill", sx, sy, math.max(r, 0))

    love.graphics.setColor(pico8Colors.yellow)
    love.graphics.circle("fill", sx, sy - 2, math.max(r - 2, 0))

    love.graphics.setColor(pico8Colors.white)
    love.graphics.circle("fill", sx, sy - 4, math.max(r - 4, 0))
  end

  table.insert(particles, particle)
end

local function explosionCloud(x, y)
  local parts = 6
  local angle = math.random()
  local step = 1 / parts
  local distance = 8

  for i = 1, parts do
    newParticle({
      x = x + pico8Math.sin(angle + step * i) * distance,
      y = y + pico8Math.cos(angle + step * i) * distance,
      r = 6,
      delay = i,
      lifespan = 30
    })
  end

  newParticle({
    x = x,
    y = y,
    r = 5,
    delay = 10,
    lifespan = 30
  })
end

local function explode(x, y)
  newParticle({
    x = x,
    y = y,
    r = 17,
    lifespan = 2
  })

  explosionCloud(x, y)
end

local function load()
end

local function update()
  for i, p in pairs(particles) do
    p:update()

    if p.lifespan <= 0 then
      table.remove(particles, i)
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

  love.graphics.print("#particles:"..#particles, 1, 1)
end

return {
  load = load,
  update = update,
  draw = draw
}
