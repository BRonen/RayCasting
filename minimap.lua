local Minimap = {}

function Minimap:new()
  local minimap = {}

  setmetatable(minimap, self)
  self.__index = self
  
  local screenW, screenH = love.graphics.getDimensions()

  minimap.canvas = love.graphics.newCanvas(screenW/3, screenH/3)

  return minimap
end

function Minimap.resize(self, width, heigth)
  self.canvas = love.graphics.newCanvas(width/3, heigth/3)
end

function Minimap.renderTo(self, renderer)
  self.canvas:renderTo(renderer)
end

function Minimap.draw(self)
  local screenW, _ = love.graphics.getDimensions()
  local width, height = self.canvas:getDimensions()
  love.graphics.draw(self.canvas, screenW-width, 0)
end

return Minimap