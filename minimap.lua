local minimap = {}
minimap.canvas = love.graphics.newCanvas(ScreenW/3, ScreenH/3)

function minimap:draw()
  local width, height = minimap.canvas:getDimensions()
  love.graphics.draw(minimap.canvas, ScreenW-width, 0)
end

return minimap