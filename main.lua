local screenW, screenH = love.graphics.getDimensions()

local Particle = require('particle')
local createGrid = require('grid')[1]
local circle = require('shapes.circle')

local intersections = {}

local minimap = require('minimap'):new()

function minimap.render(self, player, walls)
  self:renderTo(function()
    local width, height = self.canvas:getDimensions()
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle('fill', 0, 0, screenW, screenH)
    love.graphics.setColor(1,1,1,1)
    love.graphics.push()
          
    local Scale = 3

    local tx = math.floor(player.b:getX() - width  * Scale / 2)
    local ty = math.floor(player.b:getY() - height * Scale / 2)

    love.graphics.scale(1/Scale)
    love.graphics.translate(-tx, -ty)
    for _, wall in ipairs(walls) do
      if wall then
        wall:draw2d()
      end
    end
    
    for _, shot in ipairs(player.shots) do
      if shot then
        shot:draw2d()
      end
    end

    local intersection = intersections[math.floor(#intersections/2)][1]
    if intersection then
      local pt, d = intersection[1], intersection[2]
      love.graphics.setColor(100/d*2, 100/d*2, 100/d*2)
      love.graphics.line(player.b:getX(), player.b:getY(), pt.x, pt.y)
      love.graphics.circle('line', pt.x, pt.y, 5)
      love.graphics.setColor(1,1,1,1)
    end
    love.graphics.setColor(1,1,1,1)
    player:draw2D()
    love.graphics.pop()
  end)
end

RAYNUMBER = 45
RAYPRECISION = 4

Debug = false
math.randomseed(os.time()^2)

local World
local walls
local Player

function love.load()
  World = love.physics.newWorld(0, 0)
  walls = createGrid(World, screenW*2, screenH*2)
  Player = Particle:new(World, 30, 30)
end

function love.update(dt)
  local pts = Player:cast(walls)
  for i, pt in ipairs(pts) do
    intersections[i] = {pt}
  end
  pts = Player:cast(Player.shots)
  for i, pt in ipairs(pts) do
    table.insert(intersections[i], pt)
  end

  --render what is near first 
  for _, pts in ipairs(intersections) do
    table.sort(pts, function(a, b)
      --a[2] = distance of objA to Player
      --b[2] = distance of objB to Player
      --both can be nil if obj is {false}
      local aa = a[2] or 0
      local bb = b[2] or 0
      return aa > bb
    end)
  end
  Player:update(dt)
  World:update(dt)
end

function love.draw()
  if minimap then 
    minimap:render(Player, walls)
  end
  for i, intersection in ipairs(intersections) do
    for _, pt in ipairs(intersection) do
      if pt[1] then
        pt[3]:draw3d(pt[2], i)
      end
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
  Player:shot(World)
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