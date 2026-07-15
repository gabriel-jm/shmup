local p8Colors = require "pico8.colors"

--- @class TilesetData
--- @field name string
--- @field tilewidth number
--- @field tileheight number
--- @field columns number
--- @field image string
--- @field imagewidth number
--- @field imageheight number

--- @class MapLayerData
--- @field type string
--- @field id number
--- @field name string
--- @field x number
--- @field y number
--- @field width number
--- @field height number
--- @field data number[]

--- @class MapDrawProps
--- @field mapx number?
--- @field mapy number?
--- @field mapwidth number?
--- @field mapheight number?
--- @field screenx number?
--- @field screeny number?

--- @class MapData
--- @field width number
--- @field height number
--- @field tilewidth number
--- @field tileheight number
--- @field tilesets TilesetData[]
--- @field layers MapLayerData[]
--- @field draw fun(props?: MapDrawProps): self

---@param dirPath string
---@param fileName string
local function newMap(dirPath, fileName)
  local mapData = love.filesystem.load(dirPath.."/"..fileName)() ---@type MapData

  assert(mapData.tilesets)

  local firstTileset = mapData.tilesets[1]
  local firstLayer = mapData.layers[1]
  local quads = {} --- @type love.Quad[]
  local tileset = love.graphics.newImage(dirPath.."/"..firstTileset.image)
  local tilesetBatch = love.graphics.newSpriteBatch(tileset)
  local columns = firstTileset.columns
  local rows = firstTileset.imageheight / firstTileset.tileheight

  for r=0, rows-1 do
    for c=0, columns-1 do
      local x = c * firstTileset.tilewidth
      local y = r * firstTileset.tileheight

      local q = love.graphics.newQuad(
        x,
        y,
        firstTileset.tilewidth,
        firstTileset.tileheight,
        tileset
      )

      table.insert(quads, q)
    end
  end

  function mapData.draw(props)
    tilesetBatch:clear()

    local x = props.screenx or 0
    local y = props.screeny or 0

    if props.mapx and props.mapy then
      local startI = props.mapy * firstLayer.width + (props.mapx + 1)
      props.mapwidth = math.min(firstLayer.width, props.mapwidth or firstLayer.width)
      props.mapheight = math.min(firstLayer.height, props.mapheight or firstLayer.height)

      if props.mapx > 0 and props.mapwidth == firstLayer.width then
        props.mapwidth = props.mapwidth - props.mapx
      end

      if props.mapy > 0 and props.mapwidth == firstLayer.height then
        props.mapheight = props.mapheight - props.mapy
      end

      for h=0, props.mapheight - 1 do
        for w=0, props.mapwidth - 1 do
          local index = startI + firstLayer.width * h + w
          local id = firstLayer.data[index]
          local quad = quads[id]

          local tilex = x + w * firstTileset.tilewidth
          local tiley = y + h * firstTileset.tileheight

          if tilex < love.graphics.getWidth() and tiley < love.graphics.getHeight() then
            tilesetBatch:add(quad, tilex, tiley)
          end
        end
      end
    else
      for i=0, #firstLayer.data-1 do
        local r = math.floor(i / firstLayer.width)
        local c = (i % firstLayer.width) + 1

        local id = firstLayer.data[c + r * firstLayer.width]
        local quad = quads[id]

        local tilex = x + (c - 1) * firstTileset.tilewidth
        local tiley = y + r * firstTileset.tileheight

        if tilex < love.graphics.getWidth() and tiley < love.graphics.getHeight() then
          tilesetBatch:add(quad, tilex, tiley)
        end
      end
    end

    love.graphics.draw(tilesetBatch)

    return mapData
  end

  return mapData
end

local m ---@type MapData

local function load()
  m = newMap("maps", "segment-1.lua")
end

local function update()
end

local function draw()
  love.graphics.clear(p8Colors.blue)

  -- 0, 3, 5, 5, 8, 8
  m.draw({
    screenx = 5,
    screeny = 5,
    mapx = 0,
    mapy = 3,
    mapwidth = 18,
    mapheight = 8
  })
end

return {
  load = load,
  update = update,
  draw = draw
}
