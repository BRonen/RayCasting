local Particle = require('particle')
local createWalls = require('wall')

local walls

local particle

local intersections = {}

local screenW, screenH = love.window.getMode()

function love.load()
  love.mouse.setVisible(false)
  walls = createWalls(screenW, screenH)
  particle = Particle:new(50, 50)
end

function love.update(dt)
  local pts = particle:cast(walls)
  if pts then intersections = pts end
  if love.keyboard.isDown('w') then
    particle:setPosition(particle.pos.x, particle.pos.y-10)
  end
  if love.keyboard.isDown('a') then
    particle:setPosition(particle.pos.x-10, particle.pos.y)
  end
  if love.keyboard.isDown('s') then
    particle:setPosition(particle.pos.x, particle.pos.y+10)
  end
  if love.keyboard.isDown('d') then
    particle:setPosition(particle.pos.x+10, particle.pos.y)
  end
end

function love.draw()
  for _, wall in ipairs(walls) do
    wall:draw()
  end
  for _, pt in ipairs(intersections) do
    love.graphics.push()
    love.graphics.setColor(1, 1, 1, 0.3)
    love.graphics.line(particle.pos.x, particle.pos.y, pt.x, pt.y)
    love.graphics.circle('line', pt.x, pt.y, 5)
    love.graphics.pop()
  end
  particle:draw()
  love.graphics.print('X', love.mouse.getX(), love.mouse.getY())
  
  love.graphics.print('FPS: ' .. love.timer.getFPS(), 32, screenH-30)
  love.graphics.print('Memory usage: ' .. math.floor(collectgarbage 'count') .. 'kb', 150, screenH-30)
end

function love.mousemoved(x, y)
  particle:setPosition(x, y)
end

function love.touchpressed( _, x, y)
  particle:setPosition(x, y)
end

function love.resize(width, heigth)
  screenW, screenH = width, heigth
  walls = createWalls(screenW, screenH)
end

function love.keypressed(key)
  if key == 'escape' then love.event.quit() end
end