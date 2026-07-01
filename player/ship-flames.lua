local shipFlameSprite --- @type love.Image
local shipFlameQuad --- @type love.Quad
local spriteWidth = 5
local spriteHeight = 8

local function load()
  shipFlameSprite = love.graphics.newImage("assets/sprites/ship-flame.png")
  shipFlameQuad = love.graphics.newQuad(0, 0, spriteWidth, spriteHeight, shipFlameSprite)
end

local flameSprPos = 0 -- Sprite Position
local flameAnimationPos = {0, 5, 10, 5}

local function update()
  local framePos = math.floor(T/2.5) % 4 + 1
  local currentPos = flameAnimationPos[framePos]

  if currentPos ~= flameSprPos then
    flameSprPos = currentPos
    shipFlameQuad:setViewport(
      flameSprPos,
      0,
      spriteWidth,
      spriteHeight,
      shipFlameSprite:getWidth(),
      shipFlameSprite:getHeight()
    )
  end
end

local function draw(playerX, playerY)
  love.graphics.draw(shipFlameSprite, shipFlameQuad, playerX + 4, playerY + 15)
  love.graphics.draw(shipFlameSprite, shipFlameQuad, playerX + 7, playerY + 15)
end

return {
  load = load,
  update = update,
  draw = draw
}
