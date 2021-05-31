local Circle = {}

function Circle:new(world, x, y, r, color)
  local circle = {}

  setmetatable(circle, self)
  self.__index = self
  
  circle.b = love.physics.newBody(world, x, y, 'static')
  circle.s = love.physics.newCircleShape(r)
  circle.f = love.physics.newFixture(circle.b, circle.s)
  circle.x, circle.y, circle.r = x, y, r
  circle.color = color or {1,1,1}

  return circle
end

function Circle.calculeColor(self, d)
  d = d / 100
  return {
    self.color[1]/d,
    self.color[2]/d,
    self.color[3]/d,
    1
  }
end

function Circle.draw2d(self)
  love.graphics.circle('line', self.x, self.y, self.r)
end

function Circle.draw3d(self, d, i)
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

return Circle