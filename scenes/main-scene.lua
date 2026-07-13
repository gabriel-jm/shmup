local sti = require "lib.sti"
local player = require "player.player"
local pico8Colors = require "pico8.colors"

local map
local map2
local mapBottomPx = 15 * -8

local boss = false

local function load()
  map = sti("maps/advanced-shmup-map.lua")
  map2 = sti("maps/advanced-shmup-map.lua")
  local mapSegmentsOnScreen = 2
  mapBottomPx = (
    map.height * (map.tileheight - mapSegmentsOnScreen)
  ) * -1
  map.x = 0
  map.y = mapBottomPx

  map.layers[1].height = 8

  player.load()
end

local function update(dt)
  map:update(dt)

  -- if not boss and map.y < 0 then
  --   map.y = map.y + 0.4
  -- end

  map.y = map.y + 1

  map.x = player.getHorizontalScroll()

  player.update()
end

function love:keypressed(key)
  if key == "z" then
    boss = not boss
  end
end

local function draw()
  love.graphics.clear(pico8Colors.darkPurple)

  map:drawTileLayer("2")

  player.draw()
end

return {
  load = load,
  update = update,
  draw = draw
}
