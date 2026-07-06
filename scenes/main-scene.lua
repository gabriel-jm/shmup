local sti = require "lib.sti"
local player = require "player.player"

local map
local mapBottomPx = 15 * -8

local function load()
  map = sti("maps/advanced-shmup-map.lua")
  local mapSegmentsOnScreen = 2
  mapBottomPx = (
    map.height * (map.tileheight - mapSegmentsOnScreen)
  ) * -1
  map.x = 0
  map.y = mapBottomPx

  player.load()
end

local function update(dt)
  map:update(dt)

  if map.y < 0 then
    map.y = map.y + 0.4
  end

  player.update()
end

local function draw()
  map:draw(map.x, map.y)
  player.draw()
end

return {
  load = load,
  update = update,
  draw = draw
}
