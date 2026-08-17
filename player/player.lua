local inputCode = require "player.input"
local bullets = require "player.bullets"
local shipFlames = require "player.ship-flames"

local shipSpriteQuad --- @type love.Quad
local fullShipSprite --- @type love.Image
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
  offsetY = 8
}
local sprAnimation = {
  {
    sourceX = 0,
    sourceY = 0,
    width = 15,
    height = 18,
    centerOffsetX = 6,
    centerOffsetY = 8,
    quad = {} --- @type love.Quad
  },
  {
    sourceX = 14,
    sourceY = 0,
    width = 16,
    height = 18,
    centerOffsetX = 6,
    centerOffsetY = 8,
    quad = {} --- @type love.Quad
  },
  {
    sourceX = 29,
    sourceY = 0,
    width = 9,
    height = 18,
    centerOffsetX = 8,
    centerOffsetY = 8,
    half = true,
    quad = {} --- @type love.Quad
  },
  {
    sourceX = 0,
    sourceY = 0,
    width = 15,
    height = 18,
    centerOffsetX = 8,
    centerOffsetY = 8,
    flip = true,
    quad = {} --- @type love.Quad
  },
  {
    sourceX = 14,
    sourceY = 0,
    width = 16,
    height = 18,
    centerOffsetX = 6,
    centerOffsetY = 8,
    flip = true,
    quad = {} --- @type love.Quad
  }
}
local lastInput = 0

local horizontal = 0

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

  if love.keyboard.isDown("x") then
    bullets.shoot(player.x, player.y)
  end

  bullets.update()
  shipFlames.update()

  horizontal = math.clamp((player.x - 10) / 100, 0, 1) * -16
end

local function draw()
  bullets.draw(player.x, player.y)

  love.graphics.draw(
    fullShipSprite,
    shipSpriteQuad,
    player.x - player.offsetX - math.floor(sprite.position),
    player.y - player.offsetY
  )

  shipFlames.draw(player.x, player.y)

  love.graphics.setColor(255, 0, 0)
  love.graphics.points(player.x, player.y)

  love.graphics.print(horizontal, 5, 5)
  love.graphics.print(sprite.position, 5, 10)
  love.graphics.print(math.floor(sprite.position * 2.4 + 3.5), 5, 16)
end

return {
  getHorizontalScroll = function ()
    return horizontal
  end,
  load = load,
  update = update,
  draw = draw
}
