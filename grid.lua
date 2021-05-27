local Line = require('shapes.line')
local Rect = require('shapes.rect')
local Circle = require('shapes.circle')

local function worldWalls(world, w, h)
  local lines = {}
  lines[#lines+1] = Line:new(world, 0, 0, w, 0)
  lines[#lines+1] = Line:new(world, 0, 0, 0, h)
  lines[#lines+1] = Line:new(world, 0, h, w, h)
  lines[#lines+1] = Line:new(world, w, 0, w, h)
  return lines
end

local function createLines(world, w, h)
  local lines = worldWalls(world, w, h)
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
  local grid = worldWalls(world, w, h)

  grid[#grid + 1] = Rect:new(world, 100, 100, 10, 10, {1, 1, 0})
  grid[#grid + 1] = Rect:new(world, 150, 150, 100, 100, {0, 1, 1})
  
  grid[#grid + 1] = Circle:new(world, 400, 200, 100, {1, 0, 1})

  for _=1, math.random(3, 5) do
    local x1 = math.random(w)
    local x2 = math.random(w)
    local y1 = math.random(h)
    local y2 = math.random(h)
    grid[#grid + 1] = Line:new(world, x1, y1, x2, y2, {0, 0.3, 0})
  end

  return grid
end

return {createGrid, createLines}