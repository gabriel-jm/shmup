local particles = require "particles.particle"

local function newBlob(props)
  local blob = particles.newParticle(props)

  local function getColors(p)
    if not p.colorTransition then
      return p.colors
    end

    local lifespanPercentage = 1 - (p.lifespan + p.colorVariation) / p.maxLifespan
    local colorIndex = math.floor(
      math.clamp(1 + lifespanPercentage * #p.colorTransition, 1, #p.colorTransition)
    )
    p.colors = p.colorTransition[colorIndex]

    return p.colors
  end

  function blob:draw()
    if self.delay then
      return
    end

    local sx, sy, r = self.x, self.y, self.r
    local colors = getColors(self)

    love.graphics.setColor(colors[1])
    love.graphics.circle("fill", sx, sy, math.max(r, 0))

    love.graphics.setColor(colors[2])
    love.graphics.circle("fill", sx, sy - 2, math.max(r - 1, 0))
  end

  return blob
end

return newBlob
