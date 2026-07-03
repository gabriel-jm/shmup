local muzzleSprite --- @type love.Image
local muzzleQuad --- @type love.Quad

local animation = {0, 16, 32, 48}
local animIndex = 1
local currentPos = 1
local show = false

-- add muzzle array

local function muzz()
  animIndex = 1
  show = true
end

local function load()
  muzzleSprite = love.graphics.newImage("assets/sprites/muzzle.png")
  muzzleQuad = love.graphics.newQuad(0, 0, 16, 16, muzzleSprite)
end

local function update()
  if not show then
    return
  end

  animIndex = animIndex + 1.2

  if animIndex > #animation then
    -- animIndex = 1
    show = false
  end

  if currentPos ~= animIndex then
    currentPos = math.floor(animIndex)

    muzzleQuad:setViewport(
      (currentPos - 1) * 16,
      0,
      16,
      16,
      muzzleSprite:getWidth(),
      muzzleSprite:getHeight()
    )
  end
end

local function draw(playerX, playerY)
  if not show then
    return
  end

  love.graphics.draw(muzzleSprite, muzzleQuad, playerX - 4, playerY - 7)
  love.graphics.draw(muzzleSprite, muzzleQuad, playerX + 4, playerY - 7)
end

return {
  muzz = muzz,
  load = load,
  update = update,
  draw = draw
}
