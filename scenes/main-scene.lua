local player = require "player.player"
local pico8Colors = require "pico8.colors"
local p8Map = require "pico8.map"

local map --- @type MapData
local mapx, mapy = 0, 0
local mapBottomPx = 15 * -8

local currentSegments = {}
local boss = false

local function load()
  map = p8Map.newMap("maps", "shmup-map.lua")
  local mapSegmentsOnScreen = 2
  mapBottomPx = (
    map.height * (map.tileheight - mapSegmentsOnScreen)
  ) * -1
  mapy = mapBottomPx

  player.load()
end

local function update()
  if not boss and mapy < 0 then
    mapy = mapy + 1
  end

  mapx = player.getHorizontalScroll()

  if #currentSegments < 1 then
    table.insert(currentSegments, {
      mx = 0,
      my = 0
    })
  end

  player.update()
end

function love:keypressed(key)
  if key == "z" then
    boss = not boss
  end
end

local function draw()
  love.graphics.clear(pico8Colors.darkPurple)

  love.graphics.push()
    love.graphics.translate(0, mapy)

    for _, seg in pairs(currentSegments) do
      map.draw({
        screenx = mapx,
        screeny = 200,
        mapx = seg.mx,
        mapy = seg.my,
        mapwidth = 16,
        mapheight = 8
      })
    end
  love.graphics.pop()

  love.graphics.print("mapy:"..mapy, 5, 12)
  player.draw()
end

return {
  load = load,
  update = update,
  draw = draw
}
