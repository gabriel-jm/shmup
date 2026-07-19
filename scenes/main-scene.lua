local player = require "player.player"
local pico8Colors = require "pico8.colors"
local p8Map = require "pico8.map"

local map --- @type MapData
local mapx, mapy = 0, 0

local mapSegments = {1, 0, 3, 2, 1, 0, 3, 2, 1, 0, 3, 2}
local mapSegIndex = 0
local currentSegments = {}
local boss = false

local function load()
  map = p8Map.newMap("maps", "shmup-map.lua")

  player.load()
end

local function update()
  mapy = mapy + 1
  mapx = player.getHorizontalScroll()

  local lastOffset = currentSegments[#currentSegments]
  if #currentSegments < 1 or mapy - lastOffset.offsetY > 0 then
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

    table.insert(currentSegments, {
      mx = col,
      my = row,
      offsetY = #currentSegments * 64 - 64
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

  for _, seg in pairs(currentSegments) do
    map.draw({
      screenx = mapx,
      screeny = mapy - seg.offsetY,
      mapx = seg.mx,
      mapy = seg.my,
      mapwidth = 16,
      mapheight = 8
    })
  end

  love.graphics.print("mapy:"..mapy, 5, 12)
  love.graphics.print("#currentSegments:"..#currentSegments, 5, 18)
  love.graphics.print("boss:"..(boss and "true" or "false"), 5, 24)
  player.draw()
end

return {
  load = load,
  update = update,
  draw = draw
}
