local Ray = require('ray')
local Shot = require('shot')

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

  particle.shots = {}
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
    
    local screenW, screenH = love.graphics.getDimensions()

    local id = love.touch.getTouches( )[1]
    if id then
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
      if x > screenW/2 then
        self:shot(world)
      end --just testing yet
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
      if mx > screenW/2 then
        self:shot(world)
      end --just testing yet
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
        
        --remove fisheye effect
        local a = self.angle - math.atan2(ray.dir.y, ray.dir.x)
        d = d * math.cos(a)

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
      table.insert(pts, {})
    end
  end
  return pts
end

function Particle.shot(self, World)
  local px, py = self.b:getPosition()

  --vectors
  local angle = self.angle
  local vec = {
    x = math.cos(angle),
    y = math.sin(angle)
  }

  local mag = math.sqrt(vec.x * vec.x + vec.y * vec.y)

  vec.x = vec.x * 10 / mag
  vec.y = vec.y * 10 / mag
  
  --avoid collision with player
  local x = vec.x < 0 and -3 or 3
  local y = vec.y < 0 and -3 or 3

  local shot = Shot:new(World, px+x, py+y, 0.3, {1, 0, 0})
  shot.f:setRestitution(1)
  shot.b:applyForce(vec.x, vec.y)

  table.insert(self.shots, shot)
end

function Particle.draw2D(self)
  love.graphics.setColor(1, 1, 1)
  love.graphics.circle('fill', self.b:getX(), self.b:getY(), self.s:getRadius())
end

return Particle