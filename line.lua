local Line = {}

function Line:new(world, x1, y1, x2, y2)
  local line = {}

  setmetatable(line, self)
  self.__index = self

  line.b = love.physics.newBody(world, 0, 0, 'static')
  line.s = love.physics.newEdgeShape( x1, y1, x2, y2 )
  line.f = love.physics.newFixture( line.b, line.s )

  return line
end

function Line.draw(self)
  love.graphics.line(self.b:getWorldPoints(self.s:getPoints()))
end

local function createLines(world)
  local lines = {}
  lines[#lines+1] = Line:new(world, 0, 0, ScreenW, 0)
  lines[#lines+1] = Line:new(world, 0, 0, 0, ScreenH)
  lines[#lines+1] = Line:new(world, 0, ScreenH, ScreenW, ScreenH)
  lines[#lines+1] = Line:new(world, ScreenW, 0, ScreenW, ScreenH)
  for _=1, math.random(3, 5) do
    local x1 = math.random(ScreenW);
    local x2 = math.random(ScreenW);
    local y1 = math.random(ScreenH);
    local y2 = math.random(ScreenH);
    lines[#lines + 1] = Line:new(world, x1, y1, x2, y2);
  end
  return lines
end

return {Line, createLines}