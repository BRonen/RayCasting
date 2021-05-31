local Line = {}

function Line:new(world, x1, y1, x2, y2, color)
  local line = {}

  setmetatable(line, self)
  self.__index = self

  line.b = love.physics.newBody(world, 0, 0, 'static')
  line.s = love.physics.newEdgeShape( x1, y1, x2, y2 )
  line.f = love.physics.newFixture( line.b, line.s )
  line.color = color or {1,1,1}

  return line
end

function Line.calculeColor(self, d)
  d = d / 100
  return {
    self.color[1]/d,
    self.color[2]/d,
    self.color[3]/d,
    1
  }
end

function Line.draw2d(self)
  love.graphics.line(self.b:getWorldPoints(self.s:getPoints()))
end

function Line.draw3d(self, d, i)
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

return Line