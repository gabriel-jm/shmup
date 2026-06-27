local push = require "lib.push"
local sti = require "lib.sti"

local windowWidth, windowHeight = love.window.getDesktopDimensions()
windowWidth, windowHeight = windowWidth * 0.85, windowHeight * 0.85
local targetWidth, targetHeight = 128, 128
-- local shipSprite

math.randomseed(os.time())

local map
local mapBottomPx = 15 * -8

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

  -- shipSprite = love.graphics.newImage("assets/sprites/spaceship.png")
  map = sti("maps/advanced-shmup-map.lua")
  map.x = 0
  map.y = mapBottomPx
end

function love.resize(w, h)
  push:resize(w, h)
end

function love.update(dt)
  map:update(dt)

  if love.keyboard.isDown("up") then
    map.y = math.min(0, map.y + 2)
  end

  if love.keyboard.isDown("down") then
    map.y = math.max(mapBottomPx, map.y - 2)
  end
end

function love.draw()
  push:start()

  map:draw(map.x, map.y)

  push:finish()
end
