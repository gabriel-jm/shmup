local enemyBullets = require "bullets.enemy-bullets"

local function flyInAndOut(e)
  if e.lifespan < 20 then
    e.speed.y = 1.5
  elseif e.lifespan == 60 then
    enemyBullets.add({
      x = e.x,
      y = e.y,
      sy = 1
    })
  elseif e.lifespan < 120 then
    e.speed.y = math.max(0, e.speed.y - 0.03)
  else
    e.speed.y = e.speed.y - 0.04
  end

  if e.y < -60 then
    e.dead = true
  end
end

return {
  flyInAndOut = flyInAndOut
}
