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


local getPoints = {}
getPoints['edge'] = function(obj) return obj.b:getWorldPoints(obj.s:getPoints()) end

function Ray.cast(self, target)
  if not getPoints[target.s:getType()] then
    return
  end
  local x1, y1, x2, y2 = getPoints[target.s:getType()](target)

  local x3 = self.pos.x
  local y3 = self.pos.y
  local x4 = self.pos.x + self.dir.x
  local y4 = self.pos.y + self.dir.y

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