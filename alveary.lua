
local component = require("component")
local inventory = component.inventory_controller
local robot = require("robot")
local config = require("config")
local sides = require("sides")
local utils = require("utils")
local gps = require("gps")

local function addBeePair()
  --print("Adding bee pair to Alveary")
  robot.up()
  robot.up()
  robot.select(config.princessSlot)
  inventory.dropIntoSlot(sides.forward, 1)
  robot.select(config.droneSlot)
  inventory.dropIntoSlot(sides.forward, 2)
  robot.down()
  robot.down()
end

local function isAlvearyDone()
  robot.up()
  robot.up()
  local queen = inventory.getStackInSlot(sides.forward, 1)
  robot.down()
  robot.down()
  return queen == nil
end

local function waitForQueenDeath()
  os.execute("sleep " .. config.acclimatizeSleepTime)
  while true do
    if isAlvearyDone() then
      return
    end
    os.execute("sleep " .. config.acclimatizeSleepTime)
  end
end

local function takeAllFromAlveary()
  robot.up()
  robot.up()
  robot.select(config.alvearySlot)
  for slot = 3, inventory.getInventorySize(sides.forward) do
    local item = inventory.getStackInSlot(sides.forward, slot)
    if item ~= nil then
      local stackSize = item.size
      if utils.isPrincess(item) then
        robot.select(config.princessSlot)
      else
        robot.select(config.alvearySlot)
      end
      inventory.suckFromSlot(sides.forward, slot, stackSize)
    end
  end
  robot.down()
  robot.down()
end

local function getAlvearyComponentRemaining(itemName)
  gps.moveTo(config.alvearySupplyPos)
  local count = 0
  for slot = 1, inventory.getInventorySize(sides.down) do
    local item = inventory.getStackInSlot(sides.down, slot)
    if item ~= nil and item.label == itemName then
      gps.moveHome(config.alvearySupplyPos)
      return item.size
    end
  end
  gps.moveHome(config.alvearySupplyPos)
  return 0
end

local function getAlvearyItem(itemName)
  gps.moveTo(config.alvearySupplyPos)
  for slot = 1, inventory.getInventorySize(sides.down) do
    local item = inventory.getStackInSlot(sides.down, slot)
    if item ~= nil and item.label == itemName then
      local stackSize = item.size
      inventory.suckFromSlot(sides.down, slot, stackSize)
      gps.moveHome(config.alvearySupplyPos)
      return
    end
  end
  gps.moveHome(config.alvearySupplyPos)
end

local function getFirstAvailableSlot(side)
  local slots = inventory.getInventorySize(side)
  if slots == nil then
    return nil
  end
  for slot = 1, slots do
    if inventory.getStackInSlot(side, slot) == nil then
      return slot
    end
  end
  
  return nil
end

local function getAlvearySlot(alvearyItem, side)
  for slot = 1, inventory.getInventorySize(sides.down) do
    local item = inventory.getStackInSlot(sides.down, slot)
    if item ~= nil and item.label == alvearyItem then
      return slot
    end
  end
  return getFirstAvailableSlot(sides.down)
end

local function returnAlvearyItems()
  gps.moveTo(config.alvearySupplyPos)
  for slot = 1, robot.inventorySize() do
    local item = inventory.getStackInInternalSlot(slot)
    if item ~= nil and string.find(item.label, "Alveary") then
      robot.select(slot)
      inventory.dropIntoSlot(sides.down, getAlvearySlot(item.label, sides.down))
    end
  end
  gps.moveHome(config.alvearySupplyPos)
end

local function toggleAlvearyComponent(mainItem, positions, number)
  local numEnabled = #positions - getAlvearyComponentRemaining(mainItem)
  local numAdd = number - numEnabled
  if numAdd == 0 then
    return
  end

  robot.select(config.alvearySlot)
  getAlvearyItem(numAdd < 0 and "Alveary" or mainItem)

  for i = numEnabled + 1 + (numAdd < 0 and numAdd or 0), numEnabled + (numAdd < 0 and 0 or numAdd) do
    local pos = positions[i]
    gps.moveTo(pos)
    for turn = 1, pos[4] do
      robot.turnLeft()
    end
    
    robot.swing()
    robot.place()
    
    for turn = 1, pos[4] do
      robot.turnRight()
    end
    gps.moveHome(pos)
  end

  returnAlvearyItems()
end

local function toggleStabilizer(number)
  toggleAlvearyComponent("Alveary Stabiliser", config.alvearyStabPos, number)
end

local function toggleHeater(number)
  toggleAlvearyComponent("Alveary Heater", config.alvearyTempPos, number)
end

local function toggleFan(number)
  toggleAlvearyComponent("Alveary Fan", config.alvearyTempPos, number)
end

local function toggleDryer(number)
  toggleAlvearyComponent("Alveary Hygroregulator", config.alvearyDryPos, number)
end

local function toggleHumidifier(number)
  toggleAlvearyComponent("Alveary Hygroregulator", config.alvearyDampPos, number)
end

local function isHot(temp)
  return (temp == "Warm" and 1 or ((temp == "Hot" or temp == "Hellish") and 2 or 0))
end

local function isCold(temp)
  return (temp == "Cold" and 2 or 0)
end

local function isHumid(humidity)
  return humidity == "Damp"
end

local function isDry(humidity)
  return humidity == "Arid"
end

local function acclimatizeAlveary(bee, tempOverride, humidityOverride)
  local temp = (tempOverride ~= nil) and tempOverride or bee.individual.active.species.temperature
  local humidity = (humidityOverride ~= nil) and humidityOverride or bee.individual.active.species.humidity
  
  if isHot(temp) > 0 then
    toggleHeater(isHot(temp))
  elseif isCold(temp) > 0 then
    toggleFan(isCold(temp))
  else
    toggleHeater(0)
    toggleFan(0)
  end
  
  if isDry(humidity) then
    toggleHumidifier(0)
    toggleDryer(2)
  elseif isHumid(humidity) then
    toggleDryer(0)
    toggleHumidifier(2)
  else
    toggleHumidifier(0)
    toggleDryer(0)
  end
end

return {
  addBeePair = addBeePair,
  isAlvearyDone = isAlvearyDone,
  waitForQueenDeath = waitForQueenDeath,
  takeAllFromAlveary = takeAllFromAlveary,
  toggleStabilizer = toggleStabilizer,
  acclimatizeAlveary = acclimatizeAlveary,
  toggleHeater = toggleHeater,
  isAlvearyComponentEnabled = isAlvearyComponentEnabled,
  toggleAlvearyComponent = toggleAlvearyComponent,
  returnAlvearyItems = returnAlvearyItems
}
