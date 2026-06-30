local shipSpriteQuad --- @type love.Quad
local fullShipSprite --- @type love.Image
local player = {
  x = 64,
  y = 100,
  speed = 0.3
}
local input = 0

local function load()
  fullShipSprite = love.graphics.newImage("assets/sprites/shmupjet.png")
  shipSpriteQuad = love.graphics.newQuad(32, 0, 16, 16, fullShipSprite)
end

local function updateQuad(x)
  shipSpriteQuad:setViewport(
    x,
    0,
    16,
    16,
    fullShipSprite:getWidth(),
    fullShipSprite:getHeight()
  )
end

local function update()
  input = 0

  if love.keyboard.isDown("up") then
    player.y = player.y - player.speed
    input = input + 4
  end

  if love.keyboard.isDown("down") then
    player.y = player.y + player.speed
    input = input + 8
  end

  if love.keyboard.isDown("left") then
    player.x = player.x - player.speed
    input = input + 1
  end

  if love.keyboard.isDown("right") then
    player.x = player.x + player.speed
    -- updateQuad(64)
    input = input + 2
  end
end

local function draw()
  love.graphics.draw(fullShipSprite, shipSpriteQuad, player.x, player.y)
  love.graphics.print(input, 10, 10)
end

return {
  load = load,
  update = update,
  draw = draw
}
