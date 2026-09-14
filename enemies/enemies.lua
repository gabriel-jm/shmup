local behaviors = require "enemies.enemy-behavior"
local collisions = require "collisions.collision"
local shots = require "player.bullets"
local p8Colors = require "pico8.colors"
local p8Math = require "pico8.math"
local explosion = require "explosion.explosion"
local enemyBullets = require "bullets.enemy-bullets"

local enemies = {}
local popcornEnemySprite
local popcornEnemyQuads = {}
local flashShader ---@type love.Shader

local function load()
  popcornEnemySprite = love.graphics.newImage("assets/sprites/enemy-popcorn.png")
  flashShader = love.graphics.newShader("enemies/shaders/enemy-flash.fs")

  for i=0, 2 do
    local quad = love.graphics.newQuad(
      i * 18,
      0,
      18,
      18,
      popcornEnemySprite
    )

    table.insert(popcornEnemyQuads, quad)
  end
end

local function add(props)
  local enemy = {
    x = props.x or 0,
    y = props.y or 0,
    animation = {1, 2, 3},
    animProgress = 1,
    offsetX = 8,
    offsetY = 8,
    sx = 0,
    sy = 0,
    angle = 0,
    speed = 0,
    lifespan = props.lifespan or 0,
    behavior = behaviors.behaviors.boss,
    behaviorIndex = 1,
    flash = 0,
    wait = 0,
    dist = 0,
    hp = 12
  }

  function enemy:col()
    return {
      x = math.floor(self.x - 6),
      y = math.floor(self.y - 6),
      colw = 14,
      colh = 14
    }
  end

  function enemy:shoot()
    enemyBullets.add({
      x = self.x,
      y = self.y,
      sy = 1.2
    })
  end

  table.insert(enemies, enemy)
end

local function runBehavior(e, depth)
  depth = depth or 1

  if depth > 100 then
    return
  end

  if e.behavior and e.behavior[e.behaviorIndex] then
    local beh = e.behavior[e.behaviorIndex]
    if beh then
      e.behaviorIndex = e.behaviorIndex + 1
      local quit = beh(e, enemies)

      if quit then
        return
      end
    end
  end

  runBehavior(e, depth + 1)
end

local function behave(e, player)
  if e.wait > 0 then
    e.wait = e.wait - 1
  elseif e.dist <= 0 then
    runBehavior(e)
  end

  if e.follow then
    local target = p8Math.atan2((player.x - ScrollX) - e.x, player.y - e.y)
    -- print(target, e.angle)
    local diff = target - e.angle

    if math.abs(diff) > 0.5 then
      diff = diff - math.sign(diff)
    end

    e.angle = e.angle + math.clamp(diff, -e.followSpeed, e.followSpeed)

    local distance = math.dist(player.x, player.y, e.x, e.y)

    if distance < 20 then
      e.follow = false
    end
  end

  if e.aniSpeedTarget then
    e.speed = e.speed + e.aniSpeed
    if math.abs(e.aniSpeedTarget - e.speed) < math.abs(e.aniSpeed) then
      e.speed = e.aniSpeedTarget
      e.aniSpeedTarget = nil
    end
  end

  if e.aniDirTarget then
    e.angle = e.angle + e.aniDirSpeed
    if math.abs(e.aniDirTarget - e.angle) < math.abs(e.aniDirSpeed) then
      e.angle = e.aniDirTarget
      e.aniDirTarget = nil
    end
  end
end

local function update(player)
  for i,e in pairs(enemies) do
    behave(e, player)

    -- moviment
    e.sx = p8Math.sin(e.angle) * e.speed
    e.sy = p8Math.cos(e.angle) * e.speed
    e.dist = math.max(0, e.dist - math.abs(e.speed))

    e.x = e.x + e.sx
    e.y = e.y + e.sy

    -- animation
    e.animProgress = e.animProgress + 1 / 10

    if math.floor(e.animProgress) > #e.animation then
      e.animProgress = 1
    end

    if e.flash > 0 then
      e.flash = e.flash - 1
    end

    -- aging
    e.lifespan = e.lifespan + 1

    if collisions.check(player, e) then
      player:onHit()
    end

    for si, s in pairs(shots.list) do
      if collisions.check(e, s) then
        e.flash = 3
        e.hp = e.hp - 1
        s:onHit(si)
      end
    end

    if e.hp <= 0 then
      table.remove(enemies, i)
      explosion.explode(e.x - 6, e.y)
    end

    if e.dead then
      table.remove(enemies, i)
    end
  end
end

local function draw()
  for _,e in pairs(enemies) do
    local quadIndex = e.animation[math.floor(e.animProgress)]
    local quad = popcornEnemyQuads[quadIndex]

    if e.flash > 0 then
      love.graphics.setShader(flashShader)
      flashShader:send("pink", p8Colors.pink)
    end

    love.graphics.draw(
      popcornEnemySprite,
      quad,
      (e.x - e.offsetX) + ScrollX,
      e.y - e.offsetY
    )

    love.graphics.setShader()
  end

  if #enemies > 0 then
    love.graphics.print("behavior:"..enemies[1].behaviorIndex, 5, 5)
  end
end

return {
  list = enemies,
  load = load,
  add = add,
  update = update,
  draw = draw
}
