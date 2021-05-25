local screenW, screenH = love.graphics.getDimensions()

local Particle = require('particle')
local createGrid = require('grid')[1]
local Rect = require('shapes.rect') 

local intersections = {}

local minimap = require('minimap'):new()

RAYNUMBER = 45
RAYPRECISION = 2

Debug = false
math.randomseed(os.time()^2)

local World
local walls
local Player

--function love.load()
  World = love.physics.newWorld(0, 0)
  walls = createGrid(World, screenW*2, screenH*2)
  Player = Particle:new(World, 30, 30)
--end

function love.update(dt)
  local pts = Player:cast(walls)
  if pts then intersections = pts end
  Player:update(dt)
  World:update(dt)

  if minimap then 
    minimap:renderTo(function()
      local width, height = minimap.canvas:getDimensions()
      love.graphics.setColor(0, 0, 0, 1)
      love.graphics.rectangle('fill', 0, 0, screenW, screenH)
      love.graphics.setColor(1,1,1,1)
      love.graphics.push()
            
      local Scale = 3

      local tx = math.floor(Player.b:getX() - width  * Scale / 2)
      local ty = math.floor(Player.b:getY() - height * Scale / 2)

      love.graphics.scale(1/Scale)
      love.graphics.translate(-tx, -ty)
      for _, wall in ipairs(walls) do
        wall:draw2d()
      end
      for _, intersection in ipairs(intersections) do
        if intersection then
          local pt, d = intersection[1], intersection[2]
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
  local pixelwidth = screenW/(RAYNUMBER*RAYPRECISION)
  for i, intersection in ipairs(intersections) do
    if intersection then
      intersection[3]:draw3d(intersection[2], i)
    end
  end

  if minimap then minimap:draw() end

  do
    local id = love.touch.getTouches( )[1]
    if id or Debug then
      love.graphics.setColor(1, 0, 0, 0.3)
      local x, y = 100, screenH-200 --up
      love.graphics.rectangle("fill",
        x, y,
        100, 100
      )

      x, y = 100, screenH-100 --down
      love.graphics.rectangle("fill",
        x, y,
        100, 100
      )

      x, y = 0, screenH-100 --left
      love.graphics.rectangle("fill",
        x, y,
        100, 100
      )

      x, y = 200, screenH-100 --right
      love.graphics.rectangle("fill",
        x, y,
        100, 100
      )
      --borders
      love.graphics.setColor(0, 0, 0, 0.8)
      x, y = 100, screenH-200 --up
      love.graphics.rectangle("line",
        x, y,
        100, 100
      )

      x, y = 100, screenH-100 --down
      love.graphics.rectangle("line",
        x, y,
        100, 100
      )

      x, y = 0, screenH-100 --left
      love.graphics.rectangle("line",
        x, y,
        100, 100
      )

      x, y = 200, screenH-100 --right
      love.graphics.rectangle("line",
        x, y,
        100, 100
      )
      love.graphics.setColor(1, 1, 1, 1)
    end
  end
  
  love.graphics.print('FPS: ' .. love.timer.getFPS(), 32, screenH-30)
  love.graphics.print('Memory usage: ' .. math.floor(collectgarbage 'count') .. 'kb', 150, screenH-30)
end


function love.mousepressed(cx, cy)
  local px, py = Player.b:getPosition()

  --vectors
  local angle = Player.angle
  local vec = {
    x = math.cos(-angle),
    y = math.sin(-angle)
  }

  --fix collision of shot with player
  local x = vec.x < 0 and -5 or 5
  local y = vec.y < 0 and -5 or 5

  --local shot = Rect:new(World, px, py, 5, 5, true)

  --shot.b:applyForce(vec.y*100, vec.y*100)

  --table.insert(walls, shot)
end

function love.touchpressed( _, x, y)
end

function love.resize(width, heigth)
  screenW, screenH = width, heigth
  minimap:resize(width, heigth)
end

function love.keypressed(key)
  if key == 'escape' then love.event.quit() end
  if key == 'space' then Debug = not Debug end
end
function love.keyreleased(key)
end