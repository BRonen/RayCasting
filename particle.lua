local Ray = require('ray')

local function dist(xy1, xy2)
  local x1, y1 = xy1.x, xy1.y
  local x2, y2 = xy2.x, xy2.y
  return ((x2-x1)^2+(y2-y1)^2)^0.5
end

local Particle = {}

function Particle:new(world, x, y)
  local particle = {}

  setmetatable(particle, self)
  self.__index = self

  particle.b = love.physics.newBody(world, x-5/2, y-5/2, 'dynamic')
  particle.b:setMass(1)
  particle.s = love.physics.newCircleShape(5)
  particle.f = love.physics.newFixture(particle.b, particle.s)

  particle.angle = 0

  particle.rays = {}

  for a = -RAYNUMBER/2, RAYNUMBER/2, 1/RAYPRECISION do
    local ray = Ray:new(x, y, math.rad(a))
    particle.rays[#(particle.rays) + 1] = ray
  end

  function particle:update(dt)
    self.b:setLinearVelocity(0,0)
    local vel = 90*dt
    if love.keyboard.isDown('w') then
      self:move(vel)
    end
    if love.keyboard.isDown('a') then
      self:move(vel, -90)
    end
    if love.keyboard.isDown('s') then
      self:move(-vel)
    end
    if love.keyboard.isDown('d') then
      self:move(-vel, -90)
    end
    if love.keyboard.isDown('q') then
      self:rotate(-0.05)
    end
    if love.keyboard.isDown('e') then
      self:rotate(0.05)
    end
  end

  return particle
end

function Particle.rotate(self, angle)
  self.angle = self.angle + angle
  local i = 1
  for a = -RAYNUMBER/2, RAYNUMBER/2, 1/RAYPRECISION do
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

  self.b:setLinearVelocity(vec.x*100, vec.y*100)

  for _, ray in ipairs(self.rays) do
    ray:setPosition(self.b:getX(), self.b:getY())
  end
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
      for _, line in ipairs(target) do
        local pt = ray:cast(line)
        if pt then
          local d = dist(
            {
              x = self.b:getX(),
              y = self.b:getY()
            }, pt)
          if (d < record) then
            record = d
            closest = pt
          end
        end
      end
    end
    if closest then
      table.insert(pts, {closest, record})
    else
      table.insert(pts, {false, false})
    end
  end
  return pts
end

function Particle.draw(self)
  for _, ray in ipairs(self.rays) do
    ray:draw()
  end
  love.graphics.setColor(0, 0, 0)
  love.graphics.circle('line', self.b:getX(), self.b:getY(), self.s:getRadius())
  love.graphics.setColor(1, 1, 1)
end

return Particle