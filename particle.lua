local Ray = require('ray')

local function dist(xy1, xy2)
  local x1, y1 = xy1.x, xy1.y
  local x2, y2 = xy2.x, xy2.y
  return ((x2-x1)^2+(y2-y1)^2)^0.5
end

local Particle = {}

function Particle:new(x, y)
  local particle = {}

  setmetatable(particle, self)
  self.__index = self

  particle.pos = {
    x = x,
    y = y
  }

  particle.angle = 0

  particle.rays = {}

  for a = -RAYNUMBER/2, RAYNUMBER/2 do
    local ray = Ray:new(x, y, math.rad(a))
    particle.rays[#(particle.rays) + 1] = ray
  end

  return particle
end

function Particle.rotate(self, angle)
  self.angle = self.angle + angle
  local i = 1
  for a = -RAYNUMBER/2, RAYNUMBER/2 do
    self.rays[i]:setAngle(math.rad(a) + self.angle)
    i = i + 1
  end
end

function Particle.move(self, vel, axis)
  local angle = self.angle
  if axis then 
    angle = angle + axis
  end
  local vec = {
    x = math.cos(angle),
    y = math.sin(angle)
  }

  local mag = math.sqrt(vec.x * vec.x + vec.y * vec.y)

  vec.x = vec.x * vel / mag
  vec.y = vec.y * vel / mag

  self:setPosition(
    self.pos.x + vec.x,
    self.pos.y + vec.y
  )
end

function Particle.cast(self, targets)
  if type(targets) ~= 'table' then
    local pts = {}
    for _, ray in ipairs(self.rays) do
      local pt = ray:cast(targets)
      if pt then table.insert(pts, pt) end
    end
    return pts
  end
  local pts = {}
  for _, ray in ipairs(self.rays) do
    local closest = nil
    local record = 1/0
    for _, target in ipairs(targets) do
      local pt = ray:cast(target)
      if pt then
        local d = dist(self.pos, pt)
        if (d < record) then
          record = d
          closest = pt
        end
      end
    end
    if closest then
      table.insert(pts, {closest, record})
    end
  end
  return pts
end

function Particle.setPosition(self, x, y)
  self.pos.x = x
  self.pos.y = y
  for _, ray in ipairs(self.rays) do
    ray:setPosition(x, y)
  end
end

function Particle.draw(self)
  for _, ray in ipairs(self.rays) do
    ray:draw()
  end
  love.graphics.setColor(0, 0, 0)
  love.graphics.circle('line', self.pos.x, self.pos.y, 2)
  love.graphics.setColor(1, 1, 1)
end

return Particle