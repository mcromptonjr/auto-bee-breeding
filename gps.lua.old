local robot = require("robot")

local function moveTo(pos)
  for y = 1, pos[2] do
    while not robot.up() do end
  end
  for y = -1, pos[2], -1 do
    while not robot.down() do end
  end
  if pos[3] > 0 then
    robot.turnLeft()
    for z = 1, pos[3] do
      while not robot.forward() do end
    end
    robot.turnRight()
  end
  if pos[3] < 0 then
    robot.turnRight()
    for z = -1, pos[3], -1 do
      while not robot.forward() do end
    end
    robot.turnLeft()
  end
  if pos[1] < 0 then
    for x = -1, pos[1], -1 do
      while not robot.forward() do end
    end
  end
  if pos[1] > 0 then
    robot.turnAround()
    for x = 1, pos[1] do
      while not robot.forward() do end
    end
    robot.turnAround()
  end
end

-- pos - the position that the robot moved to
local function moveHome(targetPos)
  local pos = {}
  for i = 1, #targetPos do
    pos[i] = -targetPos[i]
  end
  if pos[1] > 0 then
    robot.turnAround()
    for x = 1, pos[1] do
      while not robot.forward() do end
    end
    robot.turnAround()
  end
  if pos[1] < 0 then
    for x = -1, pos[1], -1 do
      while not robot.forward() do end
    end
  end
  if pos[3] < 0 then
    robot.turnRight()
    for z = -1, pos[3], -1 do
      while not robot.forward() do end
    end
    robot.turnLeft()
  end
  if pos[3] > 0 then
    robot.turnLeft()
    for z = 1, pos[3] do
      while not robot.forward() do end
    end
    robot.turnRight()
  end
  for y = -1, pos[2], -1 do
    while not robot.down() do end
  end
  for y = 1, pos[2] do
    while not robot.up() do end
  end
end

return {
  moveTo = moveTo,
  moveHome = moveHome
}
