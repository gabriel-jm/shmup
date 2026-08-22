local player = require "player.player"
local p8Map = require "pico8.map"
local particles = require "particles.particle"
local explosion = require "explosion.explosion"
local enemies = require "enemies.enemies"
local enemyBullets = require "bullets.enemy-bullets"

local map --- @type MapData
local mapx, mapy = 0, 0

local mapSegments = {3, 3, 2, 0, 3, 2, 1, 0, 3, 2, 1, 0, 3, 2, 1, 0, 3, 2, 1, 0, 3, 2}
local mapSegIndex = 0
local currentSegments = {}
local boss = false

local function load()
  map = p8Map.newMap("maps", "shmup.lua")

  enemies.load()
  enemyBullets.load()
  explosion.load()
  player.load()
end

local function startGame()
  mapx, mapy = 0, 0
  mapSegIndex = 0
  currentSegments = {}
  boss = false
end

local function update()
  mapy = mapy + (4 / 10)
  mapx = player.getHorizontalScroll()

  local lastSeg = currentSegments[#currentSegments]
  if #currentSegments < 1 or mapy - lastSeg.offsetY > 0 then
    if boss then
      mapy = mapy - 64

      for _,seg in pairs(currentSegments) do
        seg.offsetY = seg.offsetY - 64
      end
    end

    if not boss then
      mapSegIndex = mapSegIndex + 1
    end

    local segmentId = mapSegments[mapSegIndex]

    if segmentId == nil then
      segmentId = mapSegments[1]
      mapSegIndex = 1
    end

    local col = math.floor(segmentId / 4) * 18
    local row = segmentId % 4 * 8
    local nextOffset = #currentSegments < 1
      and -64
      or lastSeg.offsetY + 64

    table.insert(currentSegments, {
      mx = col,
      my = row,
      offsetY = nextOffset
    })

    if #currentSegments > 2 and mapy - currentSegments[1].offsetY >= 128 then
      table.remove(currentSegments, 1)
    end
  end

  if T%60 == 0 then
    enemies.add({
      x = math.random(10, 124),
      y = math.random(-10, -20)
    })
  end

  player.player.col = false
  enemies.update(player.player)
  enemyBullets.update()
  particles.update()
  player.update()
end

function love:keypressed(key)
  if key == "z" then
    boss = not boss
  end

  if key == "c" then
    explosion.explode(64, 64)
  end
end

local function draw()
  for _, seg in pairs(currentSegments) do
    map.draw({
      screenx = mapx,
      screeny = mapy - seg.offsetY,
      mapx = seg.mx,
      mapy = seg.my,
      mapwidth = 18,
      mapheight = 8
    })
  end

  local scrollx = player.getHorizontalScroll()
  enemies.draw(scrollx)
  particles.draw()
  player.draw()
  enemyBullets.draw(scrollx)
end

return {
  load = load,
  update = update,
  draw = draw
}
