local robot = require("robot")
local pos = require("pos")
local nav = require("nav")

-- Make a move function that can move from anywhere to anywhere else using A*
-- Have the user specify a set of blocks or areas that the robot cannot go (chests, infusion altar, alveary, etc...)
-- Try to get movement to be as straight line as possible. No constant zig-zags
local function forward()
  while not robot.forward() do end
  pos.curPos[1] = pos.curPos[1] + pos.curDir[1]
  pos.curPos[3] = pos.curPos[3] + pos.curDir[3]
end

local function up()
  while not robot.up() do end
  pos.curPos[2] = pos.curPos[2] + 1
end

local function down()
  while not robot.down() do end
  pos.curPos[2] = pos.curPos[2] - 1
end

local function turnLeft()
  robot.turnLeft()
  local x = -pos.curDir[3]
  local z = pos.curDir[1]
  pos.curDir[1] = x
  pos.curDir[3] = z
end

local function turnRight()
  robot.turnRight()
  local x = pos.curDir[3]
  local z = -pos.curDir[1]
  pos.curDir[1] = x
  pos.curDir[3] = z
end

local function turnAround()
  robot.turnAround()
  pos.curDir[1] = -pos.curDir[1]
  pos.curDir[3] = -pos.curDir[3]
end

local function moveTo(dest)
  for y = 1, dest[2] do
    up()
  end
  for y = -1, dest[2], -1 do
    down()
  end
  if dest[1] > 0 then
    turnRight()
    for x = 1, dest[1] do
      forward()
    end
    turnLeft()
  end
  if dest[1] < 0 then
    turnLeft()
    for x = -1, dest[1], -1 do
      forward()
    end
    turnRight()
  end
  if dest[3] > 0 then
    for z = 1, dest[3] do
      forward()
    end
  end
  if dest[3] < 0 then
    turnAround()
    for z = -1, dest[3], -1 do
      forward()
    end
    turnAround()
  end
end

-- pos - the position that the robot moved to
local function moveHome()
  local dest = {0, 0, 0}
  for i = 1, 3 do
    dest[i] = -pos.curPos[i]
  end
  if dest[3] < 0 then
    turnAround()
    for z = -1, dest[3], -1 do
      forward()
    end
    turnAround()
  end
  if dest[3] > 0 then
    for z = 1, dest[3] do
      forward()
    end
  end
  if dest[1] < 0 then
    turnLeft()
    for x = -1, dest[1], -1 do
      forward()
    end
    turnRight()
  end
  if dest[1] > 0 then
    turnRight()
    for x = 1, dest[1] do
      forward()
    end
    turnLeft()
  end
  for y = -1, dest[2], -1 do
    down()
  end
  for y = 1, dest[2] do
    up()
  end
end

local function turn(dir)
  if (dir[1] ~= 0 and pos.curDir[1] == -dir[1]) or (dir[3] ~= 0 and pos.curDir[3] == -dir[3]) then
    robot.turnAround()
  elseif (dir[3] ~= 0 and pos.curDir[1] == dir[3]) or (dir[1] ~= 0 and pos.curDir[3] == -dir[1]) then
    robot.turnLeft()
  elseif (dir[3] ~= 0 and pos.curDir[1] == -dir[3]) or (dir[1] ~= 0 and pos.curDir[3] == dir[1]) then
    robot.turnRight()
  end
  pos.curDir = {dir[1], dir[2], dir[3]}
end

local function turnTowards(to)
  local from = pos.curPos
  local dir = {to[1] - from[1], to[2] - from[2], to[3] - from[3]}
  
  turn(dir)
end

local function move(dest)
  local path = nav.a_star(pos.curPos, dest)
  for i = #path, 1, -1 do
    if not(path[i][1] == pos.curPos[1] and path[i][2] == pos.curPos[2] and path[i][3] == pos.curPos[3]) then
      local upAmount = path[i][2] - pos.curPos[2]
      if upAmount > 0 then
        up()
      elseif upAmount < 0 then
        down()
      else
        turnTowards(path[i])
        forward()
      end
    end
  end
end

local function moveCircle(radius, callback)
  turn({1, 0, 0})
  for s = 1, 4 do
    for i = 1, radius do
      callback(pos.curPos)
      if s == 4 and i == radius then
        up()
      else
        forward()
      end
    end
    turnLeft()
  end
  turnLeft()
end

return {
  moveTo = moveTo,
  moveHome = moveHome,
  moveCircle = moveCircle,
  move = move,
  turn = turn,
  turnTowards = turnTowards
}
