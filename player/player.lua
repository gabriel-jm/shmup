local shipSprite
local player = {
  x = 64,
  y = 100,
  speed = 1
}

local function load()
  shipSprite = love.graphics.newImage("assets/sprites/spaceship.png")
end

local function update()
  if love.keyboard.isDown("up") then
    player.y = player.y - player.speed
  end

  if love.keyboard.isDown("down") then
    player.y = player.y + player.speed
  end

  if love.keyboard.isDown("left") then
    player.x = player.x - player.speed
  end

  if love.keyboard.isDown("right") then
    player.x = player.x + player.speed
  end
end

local function draw()
  love.graphics.draw(shipSprite, player.x, player.y)
end

return {
  load = load,
  update = update,
  draw = draw
}
