local enemyBullets = require "bullets.enemy-bullets"

local function flyInAndOut(e)
  if e.lifespan < 30 then
    e.speed.y = 1.4
  elseif e.lifespan == 60 then
    enemyBullets.add({
      x = e.x,
      y = e.y,
      sy = 1
    })
  elseif e.lifespan < 140 then
    e.speed.y = math.max(0, e.speed.y - 0.03)
  else
    e.speed.y = e.speed.y - 0.04
  end

  if e.y < -60 then
    e.dead = true
  end
end

local function heading(angle, speed, waitFrames)
  return function (en)
    en.angle = angle
    en.speed = speed

    if waitFrames then
      en.wait = waitFrames
    end
  end
end

local behaviors = {
  heading(0.1, 0.4, 20),
  heading(-0.1, 1, 30),
  heading(0, 0.4)
}

return {
  flyInAndOut = flyInAndOut,
  first = behaviors
}
