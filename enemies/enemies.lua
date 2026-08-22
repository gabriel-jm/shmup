local behaviors = require "enemies.enemy-behavior"

local enemies = {}
local popcornEnemySprite
local popcornEnemyQuads = {}

local function load()
  popcornEnemySprite = love.graphics.newImage("assets/sprites/enemy-popcorn.png")

  for i=0, 2 do
    local quad = love.graphics.newQuad(
      i * 18,
      0,
      18,
      18,
      popcornEnemySprite
    )

    table.insert(popcornEnemyQuads, quad)
  end
end

local function add(props)
  local enemy = {
    x = props.x or 0,
    y = props.y or 0,
    animation = {1, 2, 3},
    animProgress = 1,
    offsetX = 8,
    offsetY = 8,
    speed = { x = 0, y = 0 },
    lifespan = props.lifespan or 0,
    behavior = behaviors.flyInAndOut
  }

  table.insert(enemies, enemy)
end

local function update()
  for i,e in pairs(enemies) do
    if e.behavior then
      e:behavior()
    end

    -- moviment
    e.x = e.x + e.speed.x
    e.y = e.y + e.speed.y

    -- animation
    e.animProgress = e.animProgress + 1 / 10

    if math.floor(e.animProgress) > #e.animation then
      e.animProgress = 1
    end

    -- aging
    e.lifespan = e.lifespan + 1

    if e.dead then
      table.remove(enemies, i)
    end
  end
end

local function draw(xscroll)
  for _,e in pairs(enemies) do
    local quadIndex = e.animation[math.floor(e.animProgress)]
    local quad = popcornEnemyQuads[quadIndex]

    love.graphics.draw(
      popcornEnemySprite,
      quad,
      (e.x - e.offsetX) + xscroll,
      e.y - e.offsetY
    )
  end

  love.graphics.print("#enemies:"..#enemies, 5, 5)
end

return {
  load = load,
  add = add,
  update = update,
  draw = draw
}
