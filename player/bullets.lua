local bulletSprites = {
  small = {
    image = nil,
    quad = nil
  },
  big = {
    image = nil,
    quad = nil
  }
}
local shots = {}
local shotDelay = 0
local weapon = 2

local function smallShot(x, y)
  if shotDelay > 0 or #shots >= 6 then
    return
  end

  table.insert(shots, {
    x = x + 3,
    y = y + 2,
    sx = 0,
    sy = -3
  })
  table.insert(shots, {
    x = x + 9,
    y = y + 2,
    sx = 0,
    sy = -3
  })
  shotDelay = 8
end

local function bigShot(x, y)
  if shotDelay > 0 or #shots >= 12 then
    return
  end

  table.insert(shots, {
    x = x,
    y = y + 2,
    sx = 0,
    sy = -3
  })
  table.insert(shots, {
    x = x + 8,
    y = y + 2,
    sx = 0,
    sy = -3
  })
  shotDelay = 8
end

local function shot(x, y)
  if weapon == 1 then
    return smallShot(x, y)
  end

  if weapon == 2 then
    return bigShot(x, y)
  end
end

local bigBulletSprPos = 0 -- Sprite Position
local bigBulletAnimationPos = {0, 8, 16, 8}

local function animateBigBullet()
  local framePos = math.floor(T/3) % 4 + 1
  local currentPos = bigBulletAnimationPos[framePos]

  if currentPos ~= bigBulletSprPos then
    bigBulletSprPos = currentPos
    bulletSprites.big.quad:setViewport(
      bigBulletSprPos,
      0,
      8,
      16,
      bulletSprites.big.image:getWidth(),
      bulletSprites.big.image:getHeight()
    )
  end
end

local function load()
  local smallBulletSprite = love.graphics.newImage("assets/sprites/bullet.png")
  bulletSprites.small.image = smallBulletSprite

  local bigBulletSprite = love.graphics.newImage("assets/sprites/big-bullet.png")
  local bigBulletQuad = love.graphics.newQuad(0, 0, 8, 16, bigBulletSprite)
  bulletSprites.big.image = bigBulletSprite
  bulletSprites.big.quad = bigBulletQuad
end

local function update()
  if shotDelay > 0 then
    shotDelay = shotDelay - 1
  end

  for i, b in pairs(shots) do
    b.x = b.x + b.sx
    b.y = b.y + b.sy

    if b.y < -58 then
      table.remove(shots, i)
    elseif weapon == 2 then
      animateBigBullet()
    end
  end
end

local function draw()
  for _,b in pairs(shots) do
    if weapon == 1 then
      love.graphics.draw(
        bulletSprites.small.image,
        b.x,
        b.y
      )
    end

    if weapon == 2 then
      love.graphics.draw(
        bulletSprites.big.image,
        bulletSprites.big.quad,
        b.x,
        b.y
      )
    end
  end
end

return {
  shot = shot,
  load = load,
  update = update,
  draw = draw
}
