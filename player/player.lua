local inputCode = require "player.input"
local bullets = require "player.bullets"
local shipFlames = require "player.ship-flames"
local collisions = require "collisions.collision"
local enemyBullets = require "bullets.enemy-bullets"
local explosions = require "explosion.explosion"

local shipSpriteQuad --- @type love.Quad
local fullShipSprite --- @type love.Image

local lastInput = 0

local sprite = {
  position = 0, -- -1, 0, 1
  width = 18,
  height = 18
}
local player = {
  x = 64,
  y = 100,
  speed = 1.4,
  offsetX = 8,
  offsetY = 8,
  invul = 0
}

function player:col()
  return {
    x = math.floor(self.x) - ScrollX,
    y = math.floor(self.y),
    colw = 3,
    colh = 3
  }
end

function player:onHit()
  if self.invul > 0 then
    return
  end

  self.invul = 150

  Freeze(18, function ()
    self:die()
  end)
end

function player:die()
  explosions.explode(self.x, self.y)
end

local function updateQuad(position)
  sprite.position = math.clamp(position, -1, 1)

  local pos = sprite.position * 2.4 + 2.5
  shipSpriteQuad:setViewport(
    math.floor(pos) * sprite.width,
    0,
    sprite.width,
    sprite.height,
    fullShipSprite:getWidth(),
    fullShipSprite:getHeight()
  )
end

local function load()
  fullShipSprite = love.graphics.newImage("assets/sprites/shmupjet.png")
  shipSpriteQuad = love.graphics.newQuad(
    sprite.width * 2,
    0,
    sprite.width,
    sprite.height,
    fullShipSprite
  )

  bullets.load()
  shipFlames.load()
end

local function checkCollision()
  if player.invul > 0 then
    player.invul = player.invul - 1
    return
  end

  for _,b in pairs(enemyBullets.list) do
    if collisions.check(player, b) then
      player:onHit()
    end
  end
end

local dirx = {0, -1, 1,  0, 0, -0.7,  0.7, 0.7, -0.7}
local diry = {0,  0, 0, -1, 1, -0.7, -0.7, 0.7,  0.7}

local function update()
  local input = inputCode()
  local speed = player.speed

  if lastInput~=input and input >= 5 then
    player.x = math.floor(player.x) + 0.5
    player.y = math.floor(player.y) + 0.5
  end

  local targetSprite = 0
  local dx = dirx[input]
  local dy = diry[input]

  player.x = player.x + dx * speed
  player.y = player.y + dy * speed

  targetSprite = math.sign(dx)

  local bankingSpeed = 0.25
  local differenceSign = math.sign(targetSprite - sprite.position)
  local position = sprite.position + differenceSign * bankingSpeed
  local newPosition = math.clamp(position, -1, 1)

  if sprite.position ~= newPosition then
    updateQuad(newPosition)
  end

  lastInput = input

  bullets.update()
  shipFlames.update()

  ScrollX = math.floor(
    math.clamp((player.x - 10) / 108, 0, 1) * -16
  )

  if love.keyboard.isDown("x") then
    bullets.shoot(player.x - ScrollX, player.y)
  end

  checkCollision()
end

local function draw()
  bullets.draw(player.x, player.y)

  if player.invul <= 0 or T%4 == 0 then
    love.graphics.draw(
      fullShipSprite,
      shipSpriteQuad,
      player.x - player.offsetX - math.floor(sprite.position),
      math.floor(player.y - player.offsetY)
    )

    shipFlames.draw(player.x, player.y)
  end

  if player.hit then
    local pcol = player:col()
    love.graphics.rectangle("line", pcol.x + ScrollX, pcol.y, pcol.colw, pcol.colh)
  end
end

return {
  load = load,
  update = update,
  draw = draw,
  player = player
}
