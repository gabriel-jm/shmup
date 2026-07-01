local bulletSprite ---@type love.Image
local shots = {}
local shotDelay = 0

local function shot(x, y)
  if shotDelay > 0 then
    return
  end

  table.insert(shots, {
    x = x + 2,
    y = y + 2,
    sx = 0,
    sy = -1.8
  })
  table.insert(shots, {
    x = x + 10,
    y = y + 2,
    sx = 0,
    sy = -1.8
  })
  shotDelay = 8
end

local function load()
  bulletSprite = love.graphics.newImage("assets/sprites/bullet.png")
end

local function update()
  if shotDelay > 0 then
    shotDelay = shotDelay - 1
  end

  for i, b in pairs(shots) do
    b.x = b.x + b.sx
    b.y = b.y + b.sy

    if b.y < -8 then
      table.remove(shots, i)
    end
  end
end

local function draw()
  for _,b in pairs(shots) do
    love.graphics.draw(bulletSprite, b.x, b.y)
  end
end

return {
  shot = shot,
  load = load,
  update = update,
  draw = draw
}
