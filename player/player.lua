local inputCode = require "player.input"
local bullets = require "player.bullets"
local shipFlames = require "player.ship-flames"
local collisions = require "collisions.collision"
local enemyBullets = require "bullets.enemy-bullets"

local shipSpriteQuad --- @type love.Quad
local fullShipSprite --- @type love.Image

local lastInput = 0
local horizontal = 0

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
  colw = 16,
  colh = 16
}

function player:colBody()
  return {
    x = math.floor(self.x - 7) - horizontal,
    y = math.floor(self.y - 7),
    colw = 16,
    colh = 16
  }
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

  horizontal = math.clamp((player.x - 10) / 108, 0, 1) * -16

  if love.keyboard.isDown("x") then
    bullets.shoot(player.x - horizontal, player.y)
  end

  for _,b in pairs(enemyBullets.list) do
    if collisions.check(player:colBody(), b:colBody()) then
      player.col = true
    end
  end
end

local function draw()
  bullets.draw(player.x, player.y, horizontal)

  love.graphics.draw(
    fullShipSprite,
    shipSpriteQuad,
    player.x - player.offsetX - math.floor(sprite.position),
    player.y - player.offsetY
  )

  shipFlames.draw(player.x, player.y)

  if player.col then
    love.graphics.rectangle("line", player.x - 7, player.y - 7, 16, 16)
  end
end

return {
  getHorizontalScroll = function ()
    return horizontal
  end,
  load = load,
  update = update,
  draw = draw,
  player = player
}
