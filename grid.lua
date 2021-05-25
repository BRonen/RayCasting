local Line = require('shapes.line')
local Rect = require('shapes.rect')

local function createLines(world, w, h)
  local lines = {}
  lines[#lines+1] = Line:new(world, 0, 0, w, 0)
  lines[#lines+1] = Line:new(world, 0, 0, 0, h)
  lines[#lines+1] = Line:new(world, 0, h, w, h)
  lines[#lines+1] = Line:new(world, w, 0, w, h)
  for _=1, math.random(3, 5) do
    local x1 = math.random(w)
    local x2 = math.random(w)
    local y1 = math.random(h)
    local y2 = math.random(h)
    lines[#lines + 1] = Line:new(world, x1, y1, x2, y2)
  end
  return lines
end

local function createGrid(world, w, h)
  local grid = {}

  grid[#grid + 1] = Rect:new(world, 100, 100, 10, 10)
  grid[#grid + 1] = Rect:new(world, 150, 150, 100, 100, true)

  grid[#grid+1] = Line:new(world, 0, 0, w, 0)
  grid[#grid+1] = Line:new(world, 0, 0, 0, h)
  grid[#grid+1] = Line:new(world, 0, h, w, h)
  grid[#grid+1] = Line:new(world, w, 0, w, h)
  for _=1, math.random(3, 5) do
    local x1 = math.random(w)
    local x2 = math.random(w)
    local y1 = math.random(h)
    local y2 = math.random(h)
    grid[#grid + 1] = Line:new(world, x1, y1, x2, y2)
  end

  return grid
end

return {createGrid, createLines}