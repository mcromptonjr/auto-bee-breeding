
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
  gps.move(config.locs["DroneSupply"].pos)
  local set = {}
  for slot = 1, inventory.getInventorySize(sides.down) do
    local item = inventory.getStackInSlot(sides.down, slot)
    if item ~= nil and item.name == config.droneName then
      set[item.individual.displayName] = true
    end
  end
  return set
end

local function calculateBeeBreedTasks(beeType)
  local droneTypes = getAvailableDroneTypes()
  if droneTypes[beeType] then
    return {}
  end
  local taskLength = 1
  local lastTaskLength = 0
  local tasks = {[beeType] = config.beeTree[beeType]}
  tasks[beeType].depth = 1
  local stack = {[beeType] = true}
  local children = {}
  local missing = {}
  while next(stack) ~= nil do
    local child, _ = next(stack)
    stack[child] = nil
    local task = tasks[child]
    for _, parent in ipairs(task) do
      if children[parent] == nil then
        children[parent] = {}
      end
      if not droneTypes[parent] and config.beeTree[parent] == nil then
        children[parent][child] = true
        missing[parent] = true
      elseif not droneTypes[parent] then
        droneTypes[parent] = true
        stack[parent] = true
        tasks[parent] = config.beeTree[parent]
        children[parent][child] = true
      end
      if tasks[parent] ~= nil then
        tasks[parent].depth = tasks[child].depth + 1
      end
    end
  end
  
  if next(missing) ~= nil then
    local parent, _ = next(missing)
    local errorMessage = parent
    while parent ~= nil do
      local child, _ = children[parent]
      errorMessage = errorMessage .. "," .. child
      parent = child
    end
    print("Insufficient bees for breeding:", errorMessage)
    return {}
  end
  
  local taskDepths = {}
  for bee, task in pairs(tasks) do
    if taskDepths[task.depth] == nil then
      for d = #taskDepths + 1, task.depth do
        table.insert(taskDepths, {})
      end
    end
    table.insert(taskDepths[task.depth], {[bee] = task})
  end
  
  local orderedTasks = {}
  for i = #taskDepths, 1, -1 do
    if taskDepths[i] ~= nil then
      for _, task in ipairs(taskDepths[i]) do
        table.insert(orderedTasks, task)
      end
    end
  end
  
  return orderedTasks
end

-- Assumes bee to acclimatize is in slot 16 (should be a Queen)
local function acclimatize(tempOverride, humidityOverride, mutatronIsDisabled)
  robot.select(16)
  gps.move(config.locs["Acclimatizer"].pos)
  inventory.dropIntoSlot(sides.down, getFirstAvailableSlot(sides.down))
  local isDone = false
  while not isDone do
    gps.move(config.locs["AcclimatizerResult"].pos)
    os.execute("sleep " .. config.acclimatizeSleepTime)
    isDone = inventory.suckFromSlot(sides.down, 1)
  end
  if config.enableAcclimatizeAlveary and mutatronIsDisabled then
    alveary.acclimatizeAlveary(inventory.getStackInInternalSlot(config.princessSlot), tempOverride, humidityOverride)
  end
end

local function getBestPrincess(princessType)
  robot.select(16)
  gps.move(config.locs["InProgressPrincess"].pos)
  for slot = 1, inventory.getInventorySize(sides.down) do
    local princess = inventory.getStackInSlot(sides.down, slot)
    if princess ~= nil and utils.getBeeType(princess) == princessType then
      inventory.suckFromSlot(sides.down, slot, 1)
      return
    end
  end
  gps.move(config.locs["PrincessSupply"].pos)
  for slot = 1, inventory.getInventorySize(sides.down) do
    local princess = inventory.getStackInSlot(sides.down, slot)
    if princess ~= nil and utils.getBeeType(princess) == princessType then
      inventory.suckFromSlot(sides.down, slot, 1)
      return
    end
  end
  for slot = 1, inventory.getInventorySize(sides.down) do
    local princess = inventory.getStackInSlot(sides.down, slot)
    if princess ~= nil then
      inventory.suckFromSlot(sides.down, slot, 1)
      return
    end
  end
  error("No princesses left in the supply!")
end

local function getDrone(droneType, targetType)
  robot.select(15)
  gps.move(config.locs["DroneSupply"].pos)
  local selectedSlot = 0
  for slot = 1, inventory.getInventorySize(sides.down) do
    local drone = inventory.getStackInSlot(sides.down, slot)
    if drone ~= nil and utils.getBeeType(drone) == droneType and selectedSlot == 0 then
      selectedSlot = slot
    elseif drone ~= nil and utils.getBeeType(drone) == droneType and not utils.isHybrid(drone) then
      selectedSlot = slot
      break
    end
  end
  if selectedSlot > 0 then
    inventory.suckFromSlot(sides.down, selectedSlot, 1)
  else
    error("Could not find a drone of type: ", droneType)
  end
end

local function pickUpLarvae()
  gps.move(config.locs["LarvaeOutput"].pos)
  for slot = 1, inventory.getInventorySize(sides.down) do
    local item = inventory.getStackInSlot(sides.down, slot)
    if item ~= nil then
      inventory.suckFromSlot(sides.down, slot)
    end
  end
end

local function trashUselessBees()
  gps.move(config.locs["Trash"].pos)
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
end

local function dropOffLarvae()
  gps.move(config.locs["LarvaeDropoff"].pos)
  for slot = 1, robot.inventorySize() do
    local item = inventory.getStackInInternalSlot(slot)
    if item ~= nil then
      if utils.isLarvae(item) then
        robot.select(slot)
        inventory.dropIntoSlot(sides.down, getFirstAvailableSlot(sides.down))
      end
    end
  end
end

local function dropOffDrones()
  gps.move(config.locs["ScannerDropoff"].pos)
  for slot = 1, robot.inventorySize() do
    local item = inventory.getStackInInternalSlot(slot)
    if item ~= nil then
      if utils.isDrone(item) then
        robot.select(slot)
        inventory.dropIntoSlot(sides.down, getFirstAvailableSlot(sides.down))
      end
    end
  end
end

local function dropOffPrincess()
  local item = inventory.getStackInInternalSlot(config.princessSlot)
  if item ~= nil and utils.isPrincess(item) then
    gps.move(config.locs["InProgressPrincess"].pos)
    robot.select(config.princessSlot)
    inventory.dropIntoSlot(sides.down, getFirstAvailableSlot(sides.down))
  end
end

local function getNumDrones(type, isPure)
  gps.move(config.locs["DroneSupply"].pos)
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
  
  return count
end

local function sendToBiome(biome)
  gps.move(config.biomePos[biome])
  gps.turn(config.biomeDir)
  robot.select(config.princessSlot)
  inventory.dropIntoSlot(sides.forward, getFirstAvailableSlot(sides.forward))
  robot.select(config.droneSlot)
  inventory.dropIntoSlot(sides.forward, getFirstAvailableSlot(sides.forward))
end

local function waitFromBiome()
  local isDone = false
  while not isDone do
    os.execute("sleep " .. config.acclimatizeSleepTime)
    gps.move(config.biomeFinishPos)
    gps.turn(config.biomeDir)
    for slot = 1, inventory.getInventorySize(sides.forward) do
      local item = inventory.getStackInSlot(sides.forward, slot)
      if item ~= nil then
        local stackSize = item.size
        if utils.isPrincess(item) then
          robot.select(config.princessSlot)
          isDone = true
        else
          robot.select(config.alvearySlot)
        end
        inventory.suckFromSlot(sides.forward, slot, stackSize)
      end
    end
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
