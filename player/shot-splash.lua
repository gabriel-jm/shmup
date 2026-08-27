local shotSplashSprite ---@type love.Image
local shotSplashQuads = {} ---@type love.Quad[]
local shotSplashes = {}

local function add(x, y)
  local splash = {
    x = x,
    y = y,
    animProgress = 1
  }

  table.insert(shotSplashes, splash)
end

local function load()
  shotSplashSprite = love.graphics.newImage("assets/sprites/shot-splash.png")

  for i=0, 3 do
    local quad = love.graphics.newQuad(
      i * 16,
      0,
      16,
      12,
      shotSplashSprite
    )
    table.insert(shotSplashQuads, quad)
  end
end

local function update()
  for i, s in pairs(shotSplashes) do
    s.animProgress = s.animProgress + 0.7

    if s.animProgress > #shotSplashQuads then
      table.remove(shotSplashes, i)
    end
  end
end

local function draw()
  for _,s in pairs(shotSplashes) do
    local quad = shotSplashQuads[math.floor(s.animProgress)]

    love.graphics.draw(
      shotSplashSprite,
      quad,
      s.x - 10 + ScrollX,
      s.y - 17
    )
  end
end

return {
  add = add,
  load = load,
  update = update,
  draw = draw
}
