local bullets = require "bullets.bullet"

local bulletSprite ---@type love.Image
local enemyBullets = {}

local function load()
  bulletSprite = love.graphics.newImage("assets/sprites/enemy-bullet.png")
end

local function enemyBullet(props)
  local b = bullets.new(props)
  b.sprite = bulletSprite

  function b:draw()
    local spr = self.sprite

    love.graphics.draw(
      spr,
      (self.x - 3) + ScrollX,
      self.y - 3
    )
  end

  function b:colBody()
    return {
      x = math.floor(self.x - 3),
      y = math.floor(self.y - 3),
      colw = 7,
      colh = 7
    }
  end

  return b
end

local function add(props)
  table.insert(enemyBullets, enemyBullet(props))
end

local function update()
  for i, b in pairs(enemyBullets) do
    b.x = b.x + b.sx
    b.y = b.y + b.sy

    b:animate()

    if b.y > 140 then
      table.remove(enemyBullets, i)
    end
  end
end

local function draw(x, y)
  for _,b in pairs(enemyBullets) do
    b:draw(x, y)
  end
end

return {
  list = enemyBullets,
  load = load,
  add = add,
  update = update,
  draw = draw
}
