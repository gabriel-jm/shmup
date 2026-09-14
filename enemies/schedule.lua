local enemies = require "enemies.enemies"

local schedule = {
  -- {
  --   scroll = 100,
  --   enemy = 1,
  --   x = 75,
  --   y = -20
  -- },
  -- {
  --   scroll = 100,
  --   enemy = 1,
  --   x = 60,
  --   y = -30
  -- },
  -- {
  --   scroll = 100,
  --   enemy = 1,
  --   x = 90,
  --   y = -30
  -- },
  -- {
  --   scroll = 100,
  --   enemy = 1,
  --   x = 40,
  --   y = -40
  -- },
  -- {
  --   scroll = 100,
  --   enemy = 1,
  --   x = 110,
  --   y = -40
  -- }

  {
    scroll = 60,
    enemy = 1,
    x = 70,
    y = 20
  }
}
local index = 1

local function update(scroll)
  local sched = schedule[index]

  if index > #schedule then
    return
  end

  if sched.scroll < scroll then
    enemies.add({
      x = sched.x,
      y = sched.y
    })

    index = index + 1
  end
end

return {
  update = update
}
