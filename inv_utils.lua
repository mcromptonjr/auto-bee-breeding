
local component = require("component")
local inventory = component.inventory_controller
local config = require("config")
local utils = require("utils")
local sides = require("sides")
local robot = require("robot")
local gps = require("gps")
local alveary = require("alveary")

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

local function getAvailableDroneTypes()
  gps.moveTo(config.dronePos)
  local set = {}
  for slot = 1, inventory.getInventorySize(sides.down) do
    local item = inventory.getStackInSlot(sides.down, slot)
    if item ~= nil and item.name == config.droneName then
      set[item.individual.displayName] = true
    end
  end
  gps.moveHome(config.dronePos)
  return set
end

local function calculateBeeBreedTasks()
  local droneTypes = getAvailableDroneTypes()
  local beeTreeCopy = utils.copyTable(config.beeTree)
  local tasks = {} -- This is an array of tables, each "table" is a single row
  while utils.tableLength(beeTreeCopy) > 0 do
    for k, v in pairs(beeTreeCopy) do
      if droneTypes[k] then
        beeTreeCopy[k] = nil
      elseif droneTypes[v[1]] and droneTypes[v[2]] then
        local task = {[k] = v}
        table.insert(tasks, task)
        beeTreeCopy[k] = nil
        droneTypes[k] = true
      end
    end
  end
  return tasks
end

-- Assumes bee to acclimatize is in slot 16 (should be a Queen)
local function acclimatize(tempOverride, humidityOverride)
  robot.select(16)
  gps.moveTo(config.accPos)
  inventory.dropIntoSlot(sides.down, getFirstAvailableSlot(sides.down))
  gps.moveHome(config.accPos)
  local isDone = false
  while not isDone do
    os.execute("sleep " .. config.acclimatizeSleepTime)
    gps.moveTo(config.accResPos)
    isDone = inventory.suckFromSlot(sides.down, 1)
    gps.moveHome(config.accResPos)
  end
  
  alveary.acclimatizeAlveary(inventory.getStackInInternalSlot(config.princessSlot), tempOverride, humidityOverride)
end

local function getBestPrincess(princessType)
  robot.select(16)
  gps.moveTo(config.progPrincessPos)
  for slot = 1, inventory.getInventorySize(sides.down) do
    local princess = inventory.getStackInSlot(sides.down, slot)
    if princess ~= nil and utils.getBeeType(princess) == princessType then
      inventory.suckFromSlot(sides.down, slot, 1)
      gps.moveHome(config.progPrincessPos)
      return
    end
  end
  gps.moveHome(config.progPrincessPos)
  gps.moveTo(config.princessPos)
  for slot = 1, inventory.getInventorySize(sides.down) do
    local princess = inventory.getStackInSlot(sides.down, slot)
    if princess ~= nil and utils.getBeeType(princess) == princessType then
      inventory.suckFromSlot(sides.down, slot, 1)
      gps.moveHome(config.princessPos)
      return
    end
  end
  for slot = 1, inventory.getInventorySize(sides.down) do
    local princess = inventory.getStackInSlot(sides.down, slot)
    if princess ~= nil then
      inventory.suckFromSlot(sides.down, slot, 1)
      gps.moveHome(config.princessPos)
      return
    end
  end
  gps.moveHome(config.princessPos)
  error("No princesses left in the supply!")
end

local function getDrone(droneType, targetType)
  robot.select(15)
  gps.moveTo(config.dronePos)
  local selectedSlot = 0
  for slot = 1, inventory.getInventorySize(sides.down) do
    local drone = inventory.getStackInSlot(sides.down, slot)
    if drone ~= nil and utils.getBeeType(drone) == droneType and selectedSlot == 0 then
      selectedSlot = slot
    elseif drone ~= nil and utils.getBeeType(drone) == droneType and utils.getInactiveSpecies(drone) == targetType then
      selectedSlot = slot
      break
    end
  end
  if selectedSlot > 0 then
    inventory.suckFromSlot(sides.down, selectedSlot, 1)
  else
    error("Could not find a drone of type: ", droneType)
  end
  gps.moveHome(config.dronePos)
end

local function pickUpLarvae()
  gps.moveTo(config.larvaePos)
  for slot = 1, inventory.getInventorySize(sides.down) do
    local item = inventory.getStackInSlot(sides.down, slot)
    if item ~= nil then
      inventory.suckFromSlot(sides.down, slot)
    end
  end
  gps.moveHome(config.larvaePos)
end

local function trashUselessBees()
  gps.moveTo(config.trashPos)
  local usefulTypes = utils.listUsefulBeeTypes()
  for slot = 1, robot.inventorySize() do
    if slot ~= config.princessSlot then
      local item = inventory.getStackInInternalSlot(slot)
      if item ~= nil then
        if utils.isDrone(item) or utils.isLarvae(item) then
          if not usefulTypes[utils.getBeeType(item)] then
            robot.select(slot)
            inventory.dropIntoSlot(sides.down, getFirstAvailableSlot(sides.down))
          end
        elseif slot ~= config.princessSlot and slot ~= config.droneSlot then
          robot.select(slot)
          inventory.dropIntoSlot(sides.down, getFirstAvailableSlot(sides.down))
        end
      end
    end
  end
  gps.moveHome(config.trashPos)
end

local function dropOffLarvae()
  gps.moveTo(config.larvaeDronePos)
  for slot = 1, robot.inventorySize() do
    local item = inventory.getStackInInternalSlot(slot)
    if item ~= nil then
      if utils.isLarvae(item) then
        robot.select(slot)
        inventory.dropIntoSlot(sides.down, getFirstAvailableSlot(sides.down))
      end
    end
  end
  gps.moveHome(config.larvaeDronePos)
end

local function dropOffDrones()
  gps.moveTo(config.scannerPos)
  for slot = 1, robot.inventorySize() do
    local item = inventory.getStackInInternalSlot(slot)
    if item ~= nil then
      if utils.isDrone(item) then
        robot.select(slot)
        inventory.dropIntoSlot(sides.down, getFirstAvailableSlot(sides.down))
      end
    end
  end
  gps.moveHome(config.scannerPos)
end

local function dropOffPrincess()
  local item = inventory.getStackInInternalSlot(config.princessSlot)
  if item ~= nil and utils.isPrincess(item) then
    gps.moveTo(config.progPrincessPos)
    robot.select(config.princessSlot)
    inventory.dropIntoSlot(sides.down, getFirstAvailableSlot(sides.down))
    gps.moveHome(config.progPrincessPos)
  end
end

local function getNumDrones(type, isPure)
  gps.moveTo(config.dronePos)
  local count = 0
  for slot = 1, inventory.getInventorySize(sides.down) do
    local item = inventory.getStackInSlot(sides.down, slot)
    if item ~= nil and utils.isDrone(item) then
      if utils.getBeeType(item) == type then
        if not isPure then
          count = count + inventory.getSlotStackSize(sides.down, slot)
        elseif isPure and not utils.isHybrid(item) then
          count = count + inventory.getSlotStackSize(sides.down, slot)
        end
      end
    end
  end
  
  gps.moveHome(config.dronePos)
  return count
end

local function sendToBiome(biome)
  gps.moveTo(config.biomePos[biome])
  robot.select(config.princessSlot)
  inventory.dropIntoSlot(sides.up, getFirstAvailableSlot(sides.up))
  robot.select(config.droneSlot)
  inventory.dropIntoSlot(sides.up, getFirstAvailableSlot(sides.up))
  gps.moveHome(config.biomePos[biome])
end

local function waitFromBiome()
  local isDone = false
  while not isDone do
    os.execute("sleep " .. config.acclimatizeSleepTime)
    gps.moveTo(config.biomeFinishPos)
    for slot = 1, inventory.getInventorySize(sides.up) do
      local item = inventory.getStackInSlot(sides.up, slot)
      if item ~= nil then
        local stackSize = item.size
        if utils.isPrincess(item) then
          robot.select(config.princessSlot)
          isDone = true
        else
          robot.select(config.alvearySlot)
        end
        inventory.suckFromSlot(sides.up, slot, stackSize)
      end
    end
    gps.moveHome(config.biomeFinishPos)
    dropOffLarvae()
    trashUselessBees()
  end
end

return {
  getFirstAvailableSlot = getFirstAvailableSlot,
  getAvailableDroneTypes = getAvailableDroneTypes,
  calculateBeeBreedTasks = calculateBeeBreedTasks,
  acclimatize = acclimatize,
  getBestPrincess = getBestPrincess,
  getDrone = getDrone,
  pickUpLarvae = pickUpLarvae,
  trashUselessBees = trashUselessBees,
  dropOffLarvae = dropOffLarvae,
  dropOffDrones = dropOffDrones,
  getNumDrones = getNumDrones,
  dropOffPrincess = dropOffPrincess,
  sendToBiome = sendToBiome,
  waitFromBiome = waitFromBiome
}
