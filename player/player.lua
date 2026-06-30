local inputCode = require "player.input"

local shipSpriteQuad --- @type love.Quad
local fullShipSprite --- @type love.Image
local sprite = {
  position = 2.5,
  width = 16,
  height = 16
}
local player = {
  x = 64,
  y = 100,
  speed = 1.4
}
local lastInput = 0

local function load()
  fullShipSprite = love.graphics.newImage("assets/sprites/shmupjet.png")
  shipSpriteQuad = love.graphics.newQuad(
    math.floor(sprite.position) * 16,
    0,
    sprite.width,
    sprite.height,
    fullShipSprite
  )
end

local function updateQuad(position)
  if sprite.position == position then
    return
  end

  sprite.position = math.clamp(position, 0, 4)

  shipSpriteQuad:setViewport(
    math.floor(sprite.position) * 16,
    0,
    sprite.width,
    sprite.height,
    fullShipSprite:getWidth(),
    fullShipSprite:getHeight()
  )
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

  local targetSprite = 2.5
  local bankingSpeed = 0.5
  if input > 0 then
    local dx = dirx[input]
    local dy = diry[input]

    player.x = player.x + dx * speed
    player.y = player.y + dy * speed

    if dx < 0 then
      targetSprite = 0
    elseif dx > 0 then
      targetSprite = 4
    end
  end

  if targetSprite < sprite.position then
    updateQuad(sprite.position - bankingSpeed)
  elseif targetSprite > sprite.position then
    updateQuad(sprite.position + bankingSpeed)
  end

  lastInput = input
end

local function draw()
  love.graphics.draw(fullShipSprite, shipSpriteQuad, player.x, player.y)
  love.graphics.print(sprite.position, 10, 10)
end

return {
  load = load,
  update = update,
  draw = draw
}
