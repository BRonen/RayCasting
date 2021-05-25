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
    local vel = 80*dt
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
      self:rotate(-0.02)
    end
    if love.keyboard.isDown('e') then
      self:rotate(0.02)
    end

    local id = love.touch.getTouches( )[1]
    if id then
      local _, screenH = love.graphics.getDimensions()
      local x, y = love.touch.getPosition( id )
      if
        x > 100 and x < 200 and
        y > screenH-200 and y < screenH-100
      then self:move(vel) end --up
      if
        x > 100 and x < 200 and
        y > screenH-100 and y < screenH
      then self:move(-vel) end --down
      if
        x > 000 and x < 100 and
        y > screenH-100 and y < screenH
      then self:rotate(-0.05) end --left
      if
        x > 200 and x < 300 and
        y > screenH-100 and y < screenH
      then self:rotate(0.05) end --right
    end
    if Debug then
      local mx, my = love.mouse.getPosition( )
      if
        mx > 100 and mx < 200 and
        my > screenH-200 and my < screenH-100
      then self:move(vel) end --up
      if
        mx > 100 and mx < 200 and
        my > screenH-100 and my < screenH
      then self:move(-vel) end --down
      if
        mx > 000 and mx < 100 and
        my > screenH-100 and my < screenH
      then self:rotate(-0.05) end --left
      if
        mx > 200 and mx < 300 and
        my > screenH-100 and my < screenH
      then self:rotate(0.05) end --right
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
  local pts = {}
  for _, ray in ipairs(self.rays) do

    local record = 1/0
    local closest
    local obj

    for _, target in ipairs(targets) do
      local pt = ray:cast(target)

      if pt then
        local d = dist(
          {
            x = self.b:getX(),
            y = self.b:getY()
          }, pt
        )

        if (d < record) then
          record = d
          closest = pt
          obj = target
        end
      end
    end

    if closest then
      table.insert(pts, {closest, record, obj})
    else
      table.insert(pts, false)
    end
  end
  return pts
end

function Particle.draw(self)
  love.graphics.setColor(0, 0, 0)
  love.graphics.circle('line', self.b:getX(), self.b:getY(), self.s:getRadius())
  love.graphics.setColor(1, 1, 1)
end

return Particle