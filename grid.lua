local Line = require('line')[1]

local Rect = {}

function Rect:new(world, x, y, w, h)
  local lines = {}

  setmetatable(lines, self)
  self.__index = self
  lines[#lines + 1] = Line:new(world, x, y, x+w, y)
  lines[#lines + 1] = Line:new(world, x+w, y, x+w, y+h)
  lines[#lines + 1] = Line:new(world, x+w, y+h, x, y+h)
  lines[#lines + 1] = Line:new(world, x, y+h, x, y)
  lines.w, lines.h = w, h
  lines.x, lines.y = x, y

  return lines
end

function Rect.draw(self)
  love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
end

local function createGrid(world, screenW, screenH)
  local grid = {}

  grid[#grid + 1] = Rect:new(world, 100, 100, 10, 10)
  grid[#grid + 1] = Rect:new(world, 150, 150, 100, 100)

  local width, heigth = love.graphics.getDimensions()

  grid[#grid + 1] = Rect:new(world, 0, 0, width, heigth)

  return grid
end

return {Rect, createGrid}