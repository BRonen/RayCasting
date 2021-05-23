local Ray = require('ray')

local function normalize(x,y)
  local l=(x*x+y*y)^.5
  if l==0 then
    return 0,0,0
  else
    return x/l,y/l,l
  end
end

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

  particle.rays = {}

  for a = 1, 360 do
    local ray = Ray:new(x, y, math.rad(a))
    particle.rays[#(particle.rays) + 1] = ray
    print(ray)
  end

  particle.pos = {}

  particle:setPosition(x, y)

  particle.dir = {
    x = 1,
    y = 0
  }

  return particle
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
      table.insert(pts, closest)
    end
  end
  return pts
end

function Particle.setPosition(self, x, y)
  self.pos.x = x
  self.pos.y = y
  for i, ray in ipairs(self.rays) do
    ray:setPosition(x, y)
  end
end

function Particle.lookAt(self, x, y)
  x, y = normalize(x, y)
  self.dir.x = x
  self.dir.y = y
  for _, ray in ipairs(self.rays) do
    ray:lookAt(x, y)
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