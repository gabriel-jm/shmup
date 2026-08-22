local muzzle = require "player.muzzle"
local bullet = require "bullets.bullet"

local shotSprite ---@type love.Image
local shotSfx --- @type love.Source
local shots = {}
local shotDelay = 0

local function newBigBullet(props)
  props.anim = {0, 8, 16}

  local b = bullet.new(props)
  b.sprite = shotSprite
  b.quad = love.graphics.newQuad(0, 0, 8, 16, b.sprite)

  function b:draw()
    love.graphics.draw(
      self.sprite,
      self.quad,
      self.x - 7 + ScrollX,
      self.y - 13
    )
  end

  function b:colBody()
    return {
      x = math.floor(self.x - 4),
      y = math.floor(self.y - 8),
      colw = 8,
      colh = 16
    }
  end

  return b
end

local function bigShot(x, y)
  if shotDelay > 0 or #shots >= 20 then
    return
  end

  shotDelay = 6
  table.insert(shots, newBigBullet {
    x = x,
    y = y - 6,
  })
  table.insert(shots, newBigBullet {
    x = x + 8,
    y = y - 6
  })
  muzzle.muzz()
  shotSfx:clone():play()
end

local function shoot(x, y)
  bigShot(x, y)
end

local function load()
  shotSprite = love.graphics.newImage("assets/sprites/big-bullet.png")

  shotSfx = love.audio.newSource("assets/sfx/shot.wav", "static")
  shotSfx:setVolume(0.15)
  shotSfx:setPitch(0.6)

  muzzle.load()
end

local function update()
  muzzle.update()

  if shotDelay > 0 then
    shotDelay = shotDelay - 1
  end

  for i, b in pairs(shots) do
    b.x = b.x + b.sx
    b.y = b.y + b.sy

    b:animate()

    if b.y < -58 then
      table.remove(shots, i)
    end
  end
end

local function draw(playerX, playerY)
  for _,b in pairs(shots) do
    b:draw()
  end

  muzzle.draw(playerX, playerY)
end

return {
  list = shots,
  shoot = shoot,
  load = load,
  update = update,
  draw = draw
}
