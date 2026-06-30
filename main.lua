local push = require "lib.push"
local sti = require "lib.sti"
local player = require "player.player"

local windowWidth, windowHeight = love.window.getDesktopDimensions()
windowWidth, windowHeight = windowWidth * 0.9, windowHeight * 0.9
local targetWidth, targetHeight = 128, 128

math.randomseed(os.time())

local map
local mapBottomPx = 15 * -8

function math.clamp(num, min, max)
  return math.max(min, math.min(num, max))
end

function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest")
  love.graphics.setNewFont("assets/fonts/pico8.ttf")
  push:setupScreen(targetWidth, targetHeight, windowWidth, windowHeight, {
    fullscreen = false,
    vsync = true,
    resizable = true,
    pixelperfect = true,
    canvas = true
  })

  map = sti("maps/advanced-shmup-map.lua")
  local mapSegmentsOnScreen = 2
  mapBottomPx = (
    map.height * (map.tileheight - mapSegmentsOnScreen)
  ) * -1
  map.x = 0
  map.y = mapBottomPx

  player.load()
end

function love.resize(w, h)
  push:resize(w, h)
end

function love.update(dt)
  map:update(dt)

  if map.y < 0 then
    map.y = map.y + 0.2
  end

  player.update()

  if love.keyboard.isDown("escape") then
    love.event.quit(0)
  end
end

function love.draw()
  push:start()

  map:draw(map.x, map.y)
  player.draw()

  push:finish()
end
