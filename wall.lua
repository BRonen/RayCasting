local Wall = {}

function Wall:new(x1, y1, x2, y2)
  local wall = {}

  setmetatable(wall, self)
  self.__index = self

  wall.x1 = x1
  wall.x2 = x2
  wall.y1 = y1
  wall.y2 = y2

  return wall
end

function Wall.draw(self)
  love.graphics.line(
    self.x1, self.y1,
    self.x2, self.y2
  )
end

local walls

local function createWalls(screenW, screenH)
  walls = {}
  walls[#walls+1] = Wall:new(0, 10, screenW, 10)
  walls[#walls+1] = Wall:new(10, 0, 10, screenH)
  walls[#walls+1] = Wall:new(0, screenH - 10, screenW, screenH - 10)
  walls[#walls+1] = Wall:new(screenW - 10, 0, screenW - 10, screenH)
  for _=1,4 do
    local x1 = math.random(screenW);
    local x2 = math.random(screenW);
    local y1 = math.random(screenH);
    local y2 = math.random(screenH);
    walls[#walls + 1] = Wall:new(x1, y1, x2, y2);
  end
  return walls
end

return createWalls