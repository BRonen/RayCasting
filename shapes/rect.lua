local Rect = {}

function Rect:new(world, x, y, w, h, color)
  local rect = {}

  setmetatable(rect, self)
  self.__index = self
  
  rect.b = love.physics.newBody(world, x+w/2, y+h/2, 'static')
  rect.s = love.physics.newRectangleShape(w, h)
  rect.f = love.physics.newFixture(rect.b, rect.s)
  rect.x, rect.y = x, y
  rect.w, rect.h = w, h
  rect.color = color or {100,100,100}

  return rect
end

function Rect.calculeColor(self, d)
  d = d / 100
  return {
    self.color[1]/d,
    self.color[2]/d,
    self.color[3]/d,
    1
  }
end

function Rect.draw2d(self)
  love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
end

function Rect.draw3d(self, d, i)
  local screenW, screenH = love.graphics.getDimensions()
  local pixelwidth = screenW/(RAYNUMBER*RAYPRECISION)
  local height = screenH*80/d
  local x, y = pixelwidth*(i-1), (screenH - height) / 2
  love.graphics.setColor(self:calculeColor(d))
  love.graphics.polygon('fill',
    x,            y,
    x+pixelwidth, y,
    x+pixelwidth, y+height,
    x,            y+height
  )
  love.graphics.setColor(1, 1, 1, 1)
end

return Rect