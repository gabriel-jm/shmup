local function newBullet(props)
  local anim = props.anim or {0}
  local index = math.floor(T / 4) % #anim + 1
  local bullet = {
    x = props.x or 0,
    y = props.y or 0,
    sx = props.sx or 0,
    sy = props.sy or -3,
    anim = anim,
    animIndex = index,
    curAnimPos = index
  }

  function bullet:animate()
    if #self.anim == 1 then
      return
    end

    self.animIndex = self.animIndex + 0.1

    local animIndex = math.floor(self.animIndex)

    if animIndex > #self.anim then
      self.animIndex = 1
      animIndex = 1
    end

    local newPos = self.anim[animIndex]

    if self.curAnimPos ~= newPos then
      self.curAnimPos = newPos

      self.quad:setViewport(
        self.curAnimPos,
        0,
        8,
        16,
        self.sprite:getWidth(),
        self.sprite:getHeight()
      )
    end
  end

  function bullet:draw()
    love.graphics.draw(
      self.sprite,
      self.x,
      self.y
    )
  end

  return bullet
end

return {
  new = newBullet
}
