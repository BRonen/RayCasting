local Rect = {}

function Rect:new(world, x, y, w, h, color)
  local rect = {}

  setmetatable(rect, self)
  self.__index = self
  
  rect.b = love.physics.newBody(world, 0, 0, 'static')
  rect.s = love.physics.newRectangleShape(x+w/2, y+h/2, w, h)
  rect.f = love.physics.newFixture(rect.b, rect.s)
  rect.x, rect.y = x, y
  rect.w, rect.h = w, h
  rect.color = color or {100,100,100}

  return rect
end

function Rect.calculeColor(self, d)
  return {
    self.color[1]*100/d,
    self.color[2]*100/d,
    self.color[3]*100/d,
    1
  }
end

function Rect.draw2d(self)
  local x, y = self.b:getPosition()
  love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
end

function Rect.draw3d(self, d, i)
  local screenW, screenH = love.graphics.getDimensions()
  local pixelwidth = screenW/(RAYNUMBER*RAYPRECISION)
  local height = screenH*80/d
  local x1, y1 = pixelwidth*(i-1), (screenH - height) / 2
  love.graphics.setColor(self:calculeColor(d))
  love.graphics.polygon('fill',
    x1,            y1,
    x1+pixelwidth, y1,
    x1+pixelwidth, y1+height,
    x1,            y1+height
  )
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle('line', pixelwidth*(i-1), (screenH - height) / 2, pixelwidth, height)
  love.graphics.setColor(1, 1, 1, 1)
end

return Rect