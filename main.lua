require "math.math"
local push = require "lib.push"
local mainScene = require "scenes.main-scene"

local windowWidth, windowHeight = love.window.getDesktopDimensions()
windowWidth, windowHeight = windowWidth * 0.7, windowHeight * 0.7
local targetWidth, targetHeight = 128, 128

math.randomseed(os.time())

Scene = {}

function love.load()
  T = 0 -- Frames Counter

  love.graphics.setDefaultFilter("nearest", "nearest")
  love.graphics.setNewFont("assets/fonts/pico8.ttf", 5)
  push:setupScreen(targetWidth, targetHeight, windowWidth, windowHeight, {
    fullscreen = false,
    vsync = true,
    resizable = true,
    pixelperfect = true,
    canvas = true
  })

  Scene = mainScene
  Scene.load()
end

function love.resize(w, h)
  push:resize(w, h)
end

function love.update(dt)
  T = T < 1000 and T + 1 or 0

  if love.keyboard.isDown("escape") then
    love.event.quit(0)
  end

  Scene.update(dt)
end

function love.draw()
  push:start()

  Scene.draw()

  push:finish()
end
