local Shot = {}

function Shot:new(world, x, y, r, color)
  local shot = {}

  setmetatable(shot, self)
  self.__index = self
  
  shot.b = love.physics.newBody(world, x, y, 'dynamic')
  shot.s = love.physics.newCircleShape(r)
  shot.f = love.physics.newFixture(shot.b, shot.s)
  shot.x, shot.y, shot.r = x, y, r
  shot.color = color or {1,1,1}

  return shot
end

function Shot.calculeColor(self, d)
  d = d / 100
  return {
    self.color[1]/d,
    self.color[2]/d,
    self.color[3]/d,
    1
  }
end

function Shot.draw2d(self)
  local x, y = self.b:getPosition()
  love.graphics.circle('line', x, y, self.r)
end

function Shot.draw3d(self, d, i)
  local screenW, screenH = love.graphics.getDimensions()
  local pixelwidth = screenW/(RAYNUMBER*RAYPRECISION)
  local height = screenH*1/d
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

return Shot