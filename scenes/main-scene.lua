local cartographer = require "lib.cartographer"
local player = require "player.player"
local pico8Colors = require "pico8.colors"

local map
local mapBottomPx = 15 * -8

local boss = false

local function load()
  map = cartographer.load("maps/segment-1.lua")
  local mapSegmentsOnScreen = 2
  mapBottomPx = (
    map.height * (map.tileheight - mapSegmentsOnScreen)
  ) * -1
  map.x = 0
  map.y = mapBottomPx

  -- map:getLayer("Camada de Blocos 1"):draw()

  player.load()
end

local function update(dt)
  map:update(dt)

  if not boss and map.y < 0 then
    map.y = map.y + 0.4
  end

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

  love.graphics.push()

    love.graphics.translate(map.x, map.y)
    -- map:draw()
    map:getLayer("Camada de Blocos 1"):draw()

  love.graphics.pop()

  player.draw()
end

return {
  load = load,
  update = update,
  draw = draw
}
