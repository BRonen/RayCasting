local Ray = {}

function Ray:new(x, y, angle)
  local ray = {}

  setmetatable(ray, self)
  self.__index = self

  ray.pos = {
    x = x,
    y = y
  }

  ray.dir = {
    x = math.cos(angle),
    y = math.sin(angle)
  }
  ray.angle = angle

  return ray
end

function Ray.setAngle(self, angle)
  self.dir = {
    x = math.cos(angle),
    y = math.sin(angle)
  }
end

function Ray.setPosition(self, x, y)
  self.pos.x = x
  self.pos.y = y
end

function Ray.lookAt(self, x, y)
  self.dir.x = x - self.pos.x;
  self.dir.y = y - self.pos.y;
end

function Ray.cast(self, target)
  local x1 = self.pos.x
  local y1 = self.pos.y
  local x2 = self.pos.x + self.dir.x
  local y2 = self.pos.y + self.dir.y

  local _, _, f = target.f:rayCast( x1, y1, x2, y2, 1/0, target.b:getPosition(), 0, 0)

  local HitX
  local HitY

  if f then
    HitX = x1 + (x2 - x1) * f
    HitY = y1 + (y2 - y1) * f
  end

  if HitX and HitY then
    return {
      x = HitX,
      y = HitY,
      fixture = target
    }
  else
    return false
  end

  --[[ This is the hard way to do O_o
  local den = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
  if den == 0 then
    return false
  end

  local t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / den
  local u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / den
  if t > 0 and t < 1 and u > 0 then
    local pt = {}
    pt.x = math.floor(x1 + t * (x2 - x1))
    pt.y = math.floor(y1 + t * (y2 - y1))
    return pt
  else return false end
  ]]
end

function Ray.draw(self)
  love.graphics.push()
  love.graphics.translate(self.pos.x, self.pos.y)
  love.graphics.line(
    0, 0,
    self.dir.x * 15, self.dir.y * 15
  )
  love.graphics.pop()
end

return Ray