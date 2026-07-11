local pico8Colors = require "pico8.colors"

local particles = {}

local function newParticle(props)
  local particle = {
    x = props.x,
    y = props.y,
    sx = props.sx,
    sy = props.sy,
    r = props.r or 2,
    originX = props.x,
    originY = props.y,
    delay = props.delay,
    lifespan = props.lifespan or 30,
    maxLifespan = props.lifespan or 30,
    toX = props.toX,
    toY = props.toY,
    toR = props.toR,
    radiusSpeed = props.radiusSpeed,
    speed = props.speed or 1,
    onEnd = props.onEnd,
    colors = props.colors or {pico8Colors.white, pico8Colors.white},
    colorTransition = props.colorTransition
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

    if self.sx and self.sy then
      self.x = self.x + self.sx
      self.y = self.y + self.sy

      if self.toX and self.toY then
        self.toX = self.toX + self.sx
        self.toY = self.toY + self.sy
      end
    end

    if self.toR then
      self.r = self.r + (self.toR - self.r) / (5 / self.speed)
    end

    if self.radiusSpeed then
      self.r = self.r + self.radiusSpeed
    end

    self.lifespan = self.lifespan - 1
  end

  local function getColors(p)
    if not p.colorTransition then
      return p.colors
    end

    local lifespanPercentage = 1 - p.lifespan / p.maxLifespan
    local colorIndex = math.floor(
      math.max(1 + lifespanPercentage * #p.colorTransition, 1)
    )
    p.colors = p.colorTransition[colorIndex]

    return p.colors
  end

  function particle:draw()
    if self.delay then
      return
    end

    local sx, sy, r = self.x, self.y, self.r
    local colors = getColors(self)

    love.graphics.setColor(colors[1])
    love.graphics.circle("fill", sx, sy, math.max(r, 0))

    love.graphics.setColor(colors[2])
    love.graphics.circle("fill", sx, sy - 2, math.max(r - 2, 0))
  end

  function particle:ending(index)
    if self.onEnd == "return" then
      self.lifespan = 60
      self.toR = nil
      self.radiusSpeed = -0.3
    elseif self.onEnd == "fade" then
      self.lifespan = 60
      self.toR = nil
      self.radiusSpeed = -0.2 - (math.random(1, 3) / 10)
      self.speed = self.speed / 2
      self.colors = self.colorTransition[#self.colorTransition]
    else
      table.remove(particles, index)
    end

    self.colorTransition = nil
    self.onEnd = nil
  end

  table.insert(particles, particle)
end

local function update()
  for i, p in pairs(particles) do
    p:update()

    if p.lifespan <= 0 or p.r < 0.5 then
      p:ending(i)
    end
  end
end

local function draw()
  for _, p in pairs(particles) do
    p:draw()
  end

  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print("#particles:"..#particles, 1, 1)
end

return {
  newParticle = newParticle,
  update = update,
  draw = draw
}
