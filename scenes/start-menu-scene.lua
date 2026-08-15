local p8Colors = require "pico8.colors"
local mainScene = require "scenes.main-scene"

local function load()
end

local function update()
  if love.keyboard.isDown("x") then
    SetScene(mainScene)
  end
end

local function draw()
  love.graphics.clear(p8Colors.darkPurple)

  love.graphics.print("Press X to start", 28, 64)
end

return {
  load = load,
  update = update,
  draw = draw
}
