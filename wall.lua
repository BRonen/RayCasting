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
  walls[#walls+1] = Wall:new(0, 0, screenW, 0)
  walls[#walls+1] = Wall:new(0, 0, 0, screenH)
  walls[#walls+1] = Wall:new(0, screenH, screenW, screenH)
  walls[#walls+1] = Wall:new(screenW, 0, screenW, screenH)
  for _=1, math.random(3, 5) do
    local x1 = math.random(screenW);
    local x2 = math.random(screenW);
    local y1 = math.random(screenH);
    local y2 = math.random(screenH);
    walls[#walls + 1] = Wall:new(x1, y1, x2, y2);
  end
  return walls
end

return createWalls