local pico8Colors = require "pico8.colors"

local particles = {}

local function newParticle(x, y)
  local particle = {
    x = x,
    y = y,
    r = 2,
    delay = nil,
    lifespan = math.random(30, 60)
  }

  function particle:update()
    if self.lifespan <= 0 then
      return
    end

    if self.delay then
      self.delay = self.delay <= 0
        and nil
        or self.delay - 1
      return
    end

    self.lifespan = self.lifespan - 1
    self.r = self.r + 1
  end

  function particle:draw()
    if self.delay ~= nil then
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
    local x, y = math.random(24, 104), math.random(24, 104)
    newParticle(x, y)
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
