local Circle = {}

function Circle:new(world, x, y, r, color)
  local circle = {}

  setmetatable(circle, self)
  self.__index = self
  
  circle.b = love.physics.newBody(world, 0, 0, 'static')
  circle.s = love.physics.newCircleShape(x, y, r)
  circle.f = love.physics.newFixture(circle.b, circle.s)
  circle.x, circle.y, circle.r = x, y, r
  circle.color = color or {100,100,100}

  return circle
end

function Circle.calculeColor(self, d)
  return {
    self.color[1]*100/d,
    self.color[2]*100/d,
    self.color[3]*100/d,
    1
  }
end

function Circle.draw2d(self)
  local x, y = self.b:getPosition()
  love.graphics.circle('line', self.x, self.y, self.r)
end

function Circle.draw3d(self, d, i)
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

return Circle