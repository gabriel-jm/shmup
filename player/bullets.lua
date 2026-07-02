local bulletSprites = {
  small = nil,
  big = nil
}
local shots = {}
local shotDelay = 0
local weapon = 2

local function newBullet(props)
  local anim = props.anim or {0}
  local index = T % #anim + 1
  local bullet = {
    x = props.x or 0,
    y = props.y or 0,
    sx = props.sx or 0,
    sy = props.sy or -3,
    type = props.type or "small",
    anim = anim,
    animIndex = index,
    curAnimPos = index
  }

  function bullet:animate()
    if #self.anim == 1 then
      return
    end

    self.animIndex = self.animIndex + 0.05

    local animIndex = math.floor(self.animIndex)

    if animIndex > #self.anim then
      self.animIndex = 1
    end

    local newPos = self.anim[animIndex]

    if self.curAnimPos ~= newPos then
      self.curAnimPos = newPos

      self.quad:setViewport(
        self.curAnimPos,
        0,
        8,
        16,
        self.sprite:getWidth(),
        self.sprite:getHeight()
      )
    end
  end

  return bullet
end

local function newBigBullet(props)
  local bullet = newBullet(props)
  bullet.sprite = bulletSprites.big
  bullet.quad = love.graphics.newQuad(0, 0, 8, 16, bullet.sprite)

  return bullet
end

local function smallShot(x, y)
  if shotDelay > 0 or #shots >= 6 then
    return
  end

  shotDelay = 8
  table.insert(shots, newBullet {
    x = x + 3,
    y = y + 2,
  })
  table.insert(shots, newBullet {
    x = x + 9,
    y = y + 2,
  })
end

local function bigShot(x, y)
  if shotDelay > 0 or #shots >= 100 then
    return
  end

  shotDelay = 8
  table.insert(shots, newBigBullet {
    x = x,
    y = y + 2,
    type = "big",
    anim = {0, 8, 16}
  })
  table.insert(shots, newBigBullet {
    x = x + 8,
    y = y + 2,
    type = "big",
    anim = {0, 8, 16}
  })
end

local function shot(x, y)
  if weapon == 1 then
    return smallShot(x, y)
  end

  if weapon == 2 then
    return bigShot(x, y)
  end
end

local function load()
  local smallBulletSprite = love.graphics.newImage("assets/sprites/bullet.png")
  bulletSprites.small = smallBulletSprite

  local bigBulletSprite = love.graphics.newImage("assets/sprites/big-bullet.png")
  bulletSprites.big = bigBulletSprite
end

local function update()
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

local function draw()
  for _,b in pairs(shots) do
    if weapon == 1 then
      love.graphics.draw(
        bulletSprites.small,
        b.x,
        b.y
      )
    end

    if weapon == 2 then
      love.graphics.draw(
        bulletSprites.big,
        b.quad,
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
