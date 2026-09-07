local enemyBullets = require "bullets.enemy-bullets"

local behaviors = {}

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

local function heading(angle, speed)
  return function (en)
    en.angle = angle
    en.speed = speed
    en.aniSpeedTarget = nil
  end
end

local function wait(duration)
  return function (en)
    en.wait = duration
  end
end

local function animationSpeed(target, speed)
  return function (en)
    en.aniSpeed = speed
    en.aniSpeedTarget = target
  end
end

local function animateDirection(target, speed)
  return function (en)
    en.aniDirTarget = target
    en.aniDirSpeed = speed
  end
end

local function distance(px)
  return function (en)
    en.dist = px
  end
end

local function changeBehavior(name, index)
  return function (en)
    if not behaviors[name] then
      return
    end

    en.behavior = behaviors[name]
    en.behaviorIndex = index or 1
  end
end

local function shoot()
  return function (en)
    en:shoot()
  end
end

behaviors = {
  flyIn = {
    heading(0, 0.5),
    wait(10),
    shoot(),
    distance(20),
    animationSpeed(-0.02, 0),
    changeBehavior("fromRight")
  },
  fromRight = {
    heading(-0.25, 2),
    animationSpeed(0.35, -0.05),
    distance(45),
    heading(-0.9, -0.3),
    animationSpeed(2, 0.05)
  },
  turnAround = {
    heading(0, 2),
    animationSpeed(0.35, -0.05),
    distance(38),
    shoot(),
    animateDirection(0.48, 0.015),
    animationSpeed(2, 0.1)
  }
}

return {
  flyInAndOut = flyInAndOut,
  behaviors = behaviors
}
