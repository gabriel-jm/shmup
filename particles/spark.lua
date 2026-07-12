local particles = require "particles.particle"

local function newSpark(props)
  local spark = particles.newParticle(props)

  function spark:draw()
    love.graphics.setColor(self.color)

    love.graphics.line(
      self.x,
      self.y,
      math.floor(self.x - self.sx * 2),
      math.floor(self.y - self.sy * 2)
    )
    love.graphics.line(
      self.x + 1,
      self.y,
      math.floor(self.x - self.sx * 2 + 1),
      math.floor(self.y - self.sy * 2)
    )
  end

  return spark
end

return newSpark
