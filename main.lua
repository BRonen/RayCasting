local Particle = require('particle')
local createWalls = require('wall')

local walls

local Player

local intersections = {}

local minimap

local screenW, screenH = love.graphics.getDimensions()

RAYNUMBER = 90
local Debug = false

function love.load()
  --love.mouse.setVisible(false)
  math.randomseed(os.time()^2)
  walls = createWalls(screenW, screenH)
  Player = Particle:new(50, 50)
  
  minimap = love.graphics.newCanvas(screenW/3, screenH/3)
end

function love.update(dt)
  local pts = Player:cast(walls)
  if pts then intersections = pts end
  local vel = 100*dt
  if love.keyboard.isDown('w') then
    --Player:setPosition(Player.pos.x, Player.pos.y-vel)
    Player:move(vel)
  end
  if love.keyboard.isDown('a') then
    Player:move(vel, -90)
  end
  if love.keyboard.isDown('s') then
    Player:move(-vel)
  end
  if love.keyboard.isDown('d') then
    Player:move(-vel, -90)
  end
  if love.keyboard.isDown('q') then
    Player:rotate(-0.05)
  end
  if love.keyboard.isDown('e') then
    Player:rotate(0.05)
  end
  local id = love.touch.getTouches( )[1]
  if id then
    local x, y = love.touch.getPosition( id )
    if
      x > 100 and x < 200 and
      y > screenH-200 and y < screenH-100
    then Player:move(vel) end --up
    if
      x > 100 and x < 200 and
      y > screenH-100 and y < screenH
    then Player:move(-vel) end --down
    if
      x > 000 and x < 100 and
      y > screenH-100 and y < screenH
    then Player:rotate(-0.05) end --left
    if
      x > 200 and x < 300 and
      y > screenH-100 and y < screenH
    then Player:rotate(0.05) end --right
  end
  if Debug then
    local mx, my = love.mouse.getPosition( )
    if
      mx > 100 and mx < 200 and
      my > screenH-200 and my < screenH-100
    then Player:move(vel) end --up
    if
      mx > 100 and mx < 200 and
      my > screenH-100 and my < screenH
    then Player:move(-vel) end --down
    if
      mx > 000 and mx < 100 and
      my > screenH-100 and my < screenH
    then Player:rotate(-0.05) end --left
    if
      mx > 200 and mx < 300 and
      my > screenH-100 and my < screenH
    then Player:rotate(0.05) end --right
  end
end

function love.draw()
  local pixelwidth = screenW/RAYNUMBER
  for i, intersection in ipairs(intersections) do
    local pt, d = intersection[1], intersection[2]
    local width = 10000/d
    love.graphics.setColor(100/d, 100/d, 100/d)
    love.graphics.rectangle('fill', pixelwidth*(i-1), (screenH - width) / 2, pixelwidth, width)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('line', pixelwidth*(i-1), (screenH - width) / 2, pixelwidth, width)
    love.graphics.setColor(1, 1, 1, 1)
  end

  do
    local width, height = minimap:getDimensions()
    minimap:renderTo(
      function()
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle('fill', 0, 0, screenW, screenH)
        love.graphics.setColor(1,1,1,1)
        love.graphics.push()
              
        local x, y = Player.pos.x, Player.pos.y
        local Scale = 3

        local tx = math.floor(x - width  * Scale / 2)
        local ty = math.floor(y - height * Scale / 2)

        love.graphics.scale(1/Scale)
        love.graphics.translate(-tx, -ty)
        for _, wall in ipairs(walls) do
          wall:draw()
        end
        for _, intersection in ipairs(intersections) do
          local pt, d = intersection[1], intersection[2]
          love.graphics.setColor(100/d, 100/d, 100/d, 100/d)
          love.graphics.line(Player.pos.x, Player.pos.y, pt.x, pt.y)
          love.graphics.circle('line', pt.x, pt.y, 5)
          love.graphics.setColor(1,1,1,1)
        end
        Player:draw()
        love.graphics.pop()
      end
    )
    love.graphics.draw(minimap, screenW-width, 0)
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


function love.mousemoved(x, y)
end

function love.touchpressed( _, x, y)
end

function love.resize(width, heigth)
  screenW, screenH = width, heigth
  walls = createWalls(screenW, screenH)
end

function love.keypressed(key)
  if key == 'escape' then love.event.quit() end
  if key == 'space' then Debug = not Debug end
end
function love.keyreleased(key)
  if key == 'escape' then love.event.quit() end
  if key == 'space' then end
end