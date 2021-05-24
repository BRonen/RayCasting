ScreenW, ScreenH = love.graphics.getDimensions()

local Particle = require('particle')
local createGrid = require('grid')[2]

local intersections = {}

local minimap = require('minimap')

RAYNUMBER = 45
RAYPRECISION = 2

local Debug = false
math.randomseed(os.time()^2)

local World = love.physics.newWorld(0, 0)

local walls = createGrid(World)

local Player = Particle:new(World, 500, 500)

function love.load()
end

function love.update(dt)
  local pts = Player:cast(walls)
  if pts then intersections = pts end
  Player:update(dt)
  World:update(dt)
  --[[local id = love.touch.getTouches( )[1]
  if id then
    local x, y = love.touch.getPosition( id )
    if
      x > 100 and x < 200 and
      y > ScreenH-200 and y < ScreenH-100
    then Player:move(vel) end --up
    if
      x > 100 and x < 200 and
      y > ScreenH-100 and y < ScreenH
    then Player:move(-vel) end --down
    if
      x > 000 and x < 100 and
      y > ScreenH-100 and y < ScreenH
    then Player:rotate(-0.05) end --left
    if
      x > 200 and x < 300 and
      y > ScreenH-100 and y < ScreenH
    then Player:rotate(0.05) end --right
  end
  if Debug then
    local mx, my = love.mouse.getPosition( )
    if
      mx > 100 and mx < 200 and
      my > ScreenH-200 and my < ScreenH-100
    then Player:move(vel) end --up
    if
      mx > 100 and mx < 200 and
      my > ScreenH-100 and my < ScreenH
    then Player:move(-vel) end --down
    if
      mx > 000 and mx < 100 and
      my > ScreenH-100 and my < ScreenH
    then Player:rotate(-0.05) end --left
    if
      mx > 200 and mx < 300 and
      my > ScreenH-100 and my < ScreenH
    then Player:rotate(0.05) end --right
  end]]

  if minimap then 
    minimap.canvas:renderTo(function()
      local width, height = minimap.canvas:getDimensions()
      love.graphics.setColor(0, 0, 0, 1)
      love.graphics.rectangle('fill', 0, 0, ScreenW, ScreenH)
      love.graphics.setColor(1,1,1,1)
      love.graphics.push()
            
      local Scale = 3

      local tx = math.floor(Player.b:getX() - width  * Scale / 2)
      local ty = math.floor(Player.b:getY() - height * Scale / 2)

      love.graphics.scale(1/Scale)
      love.graphics.translate(-tx, -ty)
      for _, wall in ipairs(walls) do
        wall:draw()
      end
      for _, intersection in ipairs(intersections) do
        local pt, d = intersection[1], intersection[2]
        if d then
          love.graphics.setColor(100/d*2, 100/d*2, 100/d*2)
          love.graphics.line(Player.b:getX(), Player.b:getY(), pt.x, pt.y)
          love.graphics.circle('line', pt.x, pt.y, 5)
          love.graphics.setColor(1,1,1,1)
        end
      end
      Player:draw()
      love.graphics.pop()
    end)
  end
end

function love.draw()
  local pixelwidth = ScreenW/(RAYNUMBER*RAYPRECISION)
  for i, intersection in ipairs(intersections) do
    local pt, d = intersection[1], intersection[2]
    if d then
      local width = ScreenH*100/d
      love.graphics.setColor(100/d, 100/d, 100/d)
      love.graphics.rectangle('fill', pixelwidth*(i-1), (ScreenH - width) / 2, pixelwidth, width)
      love.graphics.setColor(0, 0, 0)
      love.graphics.rectangle('line', pixelwidth*(i-1), (ScreenH - width) / 2, pixelwidth, width)
      love.graphics.setColor(1, 1, 1, 1)
    end
  end

  if minimap then minimap:draw() end

  --[[do GUI
    local id = love.touch.getTouches( )[1]
    if id or Debug then
      love.graphics.setColor(1, 0, 0, 0.3)
      local x, y = 100, ScreenH-200 --up
      love.graphics.rectangle("fill",
        x, y,
        100, 100
      )

      x, y = 100, ScreenH-100 --down
      love.graphics.rectangle("fill",
        x, y,
        100, 100
      )

      x, y = 0, ScreenH-100 --left
      love.graphics.rectangle("fill",
        x, y,
        100, 100
      )

      x, y = 200, ScreenH-100 --right
      love.graphics.rectangle("fill",
        x, y,
        100, 100
      )
      --borders
      love.graphics.setColor(0, 0, 0, 0.8)
      x, y = 100, ScreenH-200 --up
      love.graphics.rectangle("line",
        x, y,
        100, 100
      )

      x, y = 100, ScreenH-100 --down
      love.graphics.rectangle("line",
        x, y,
        100, 100
      )

      x, y = 0, ScreenH-100 --left
      love.graphics.rectangle("line",
        x, y,
        100, 100
      )

      x, y = 200, ScreenH-100 --right
      love.graphics.rectangle("line",
        x, y,
        100, 100
      )
      love.graphics.setColor(1, 1, 1, 1)
    end
  end]]
  
  love.graphics.print('FPS: ' .. love.timer.getFPS(), 32, ScreenH-30)
  love.graphics.print('Memory usage: ' .. math.floor(collectgarbage 'count') .. 'kb', 150, ScreenH-30)
end


function love.mousemoved(x, y)
end

function love.touchpressed( _, x, y)
end

function love.resize(width, heigth)
  ScreenW, ScreenH = width, heigth
  walls = createGrid()
end

function love.keypressed(key)
  if key == 'escape' then love.event.quit() end
  if key == 'space' then Debug = not Debug end
end
function love.keyreleased(key)
end