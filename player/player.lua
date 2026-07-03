local inputCode = require "player.input"
local bullets = require "player.bullets"
local shipFlames = require "player.ship-flames"

local shipSpriteQuad --- @type love.Quad
local fullShipSprite --- @type love.Image
local sprite = {
  position = 0, -- -1, 0, 1
  width = 16,
  height = 16
}
local player = {
  x = 64,
  y = 100,
  speed = 1.4
}
local lastInput = 0

local function updateQuad(position)
  sprite.position = math.clamp(position, -1, 1)

  local pos = sprite.position * 2.4 + 2.5
  shipSpriteQuad:setViewport(
    math.floor(pos) * 16,
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
    32,
    0,
    sprite.width,
    sprite.height,
    fullShipSprite
  )

  bullets.load()
  shipFlames.load()
end

local dirx = {-1, 1,  0, 0, -0.7,  0.7, 0.7, -0.7}
local diry = { 0, 0, -1, 1, -0.7, -0.7, 0.7,  0.7}

local function update()
  local input = inputCode()
  local speed = player.speed

  if lastInput~=input and input >= 5 then
    player.x = math.floor(player.x) + 0.5
    player.y = math.floor(player.y) + 0.5
  end

  local targetSprite = 0
  if input > 0 then
    local dx = dirx[input]
    local dy = diry[input]

    player.x = player.x + dx * speed
    player.y = player.y + dy * speed

    targetSprite = math.sign(dx)
  end

  local bankingSpeed = 0.25
  local differenceSign = math.sign(targetSprite - sprite.position)
  local position = sprite.position + differenceSign * bankingSpeed
  local newPosition = math.clamp(position, -1, 1)

  if sprite.position ~= newPosition then
    updateQuad(newPosition)
  end

  lastInput = input

  if love.keyboard.isDown("x") then
    bullets.shot(player.x, player.y)
  end

  bullets.update()
  shipFlames.update()
end

local function draw()
  bullets.draw(player.x, player.y)

  love.graphics.draw(fullShipSprite, shipSpriteQuad, player.x, player.y)

  shipFlames.draw(player.x, player.y)
end

return {
  load = load,
  update = update,
  draw = draw
}
