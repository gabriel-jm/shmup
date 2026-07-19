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

  local function fillMapBatch(mapx, mapy, mapwidth, mapheight, sx, sy)
    local startI = mapy * firstLayer.width + mapx

    if mapx > 0 and mapwidth == firstLayer.width then
      mapwidth = mapwidth - mapx
    end

    if mapy > 0 and mapheight == firstLayer.height then
      mapheight = mapheight - mapy
    end

    local size = mapwidth * mapheight

    for i=0, size-1 do
      local r = math.floor(i / mapwidth)
      local c = (i % mapwidth) + 1

      local index = startI + firstLayer.width * r + c
      local id = firstLayer.data[index]
      local quad = quads[id]

      local tilex = sx + (c -1) * firstTileset.tilewidth
      local tiley = sy + r * firstTileset.tileheight

      tilesetBatch:add(quad, tilex, tiley)
    end
  end

  function mapData.draw(props)
    tilesetBatch:clear()

    props = props or {}
    local mapx = props.mapx or 0
    local mapy = props.mapy or 0
    local mapwidth = math.min(firstLayer.width, props.mapwidth or firstLayer.width)
    local mapheight = math.min(firstLayer.height, props.mapheight or firstLayer.height)
    local sx = props.screenx or 0
    local sy = props.screeny or 0

    fillMapBatch(mapx, mapy, mapwidth, mapheight, sx, sy)

    love.graphics.draw(tilesetBatch)

    return mapData
  end

  return mapData
end

return {
  newMap = newMap
}
