local behaviors = require "enemies.enemy-behavior"
local collisions = require "collisions.collision"
local shots = require "player.bullets"
local p8Colors = require "pico8.colors"

local enemies = {}
local popcornEnemySprite
local popcornEnemyQuads = {}
local flashShader ---@type love.Shader

local function load()
  popcornEnemySprite = love.graphics.newImage("assets/sprites/enemy-popcorn.png")
  flashShader = love.graphics.newShader("shaders/enemy-flash.fs")

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
    behavior = behaviors.flyInAndOut,
    flash = 0
  }

  function enemy:colBody()
    return {
      x = math.floor(self.x - 7),
      y = math.floor(self.y - 7),
      colw = 16,
      colh = 16
    }
  end

  table.insert(enemies, enemy)
end

local function update(player)
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

    if e.flash > 0 then
      e.flash = e.flash - 1
    end

    -- aging
    e.lifespan = e.lifespan + 1

    local eColBody = e:colBody()
    if collisions.check(player:colBody(), eColBody) then
      player.col = true
    end

    for si, s in pairs(shots.list) do
      if collisions.check(eColBody, s:colBody()) then
        e.flash = 2
        table.remove(shots.list, si)
      end
    end

    if e.dead then
      table.remove(enemies, i)
    end
  end
end

local function draw()
  for _,e in pairs(enemies) do
    local quadIndex = e.animation[math.floor(e.animProgress)]
    local quad = popcornEnemyQuads[quadIndex]

    if e.flash > 0 then
      love.graphics.setShader(flashShader)
      flashShader:send("targetColor", p8Colors.red)
    end

    love.graphics.draw(
      popcornEnemySprite,
      quad,
      (e.x - e.offsetX) + ScrollX,
      e.y - e.offsetY
    )

    love.graphics.setShader()
  end

  love.graphics.print("#enemies:"..#enemies, 5, 5)
end

return {
  load = load,
  add = add,
  update = update,
  draw = draw
}
