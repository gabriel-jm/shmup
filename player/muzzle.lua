local muzzleSprite --- @type love.Image
local muzzleQuad --- @type love.Quad

local animation = {0, 16, 32, 48}
local animationEnd = #animation + 0.95

local muzzles = {}

local function newMuzzle()
  local muzz = {
    quad = love.graphics.newQuad(0, 0, 16, 16, muzzleSprite),
    animProgress = 1,
    currentAnimIndex = 1
  }

  table.insert(muzzles, muzz)
end

local function muzz()
  newMuzzle()
end

local function load()
  muzzleSprite = love.graphics.newImage("assets/sprites/muzzle.png")
end

local function update()
  for i, m in pairs(muzzles) do
    m.animProgress = m.animProgress + 0.75

    if m.animProgress > animationEnd then
      table.remove(muzzles, i)
      goto continue
    end

    if m.currentAnimIndex ~= math.floor(m.animProgress) then
      m.currentAnimIndex = math.floor(m.animProgress)

      local imageX = (m.currentAnimIndex - 1) * 16
      m.quad:setViewport(
        imageX,
        0,
        16,
        16,
        muzzleSprite:getWidth(),
        muzzleSprite:getHeight()
      )
    end

    ::continue::
  end
end

local function draw(playerX, playerY)
  for _,m in pairs(muzzles) do
    love.graphics.draw(muzzleSprite, m.quad, playerX - 4, playerY - 7)
    love.graphics.draw(muzzleSprite, m.quad, playerX + 4, playerY - 7)
  end

  love.graphics.print("muzzles:"..#muzzles, 5, 5)
end

return {
  muzz = muzz,
  load = load,
  update = update,
  draw = draw
}
