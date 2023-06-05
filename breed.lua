
local component = require("component")
local inventory = component.inventory_controller
local redstone = component.redstone
local inv_utils = require("inv_utils")
local config = require("config")
local utils = require("utils")
local alveary = require("alveary")
local gps = require("gps")
local robot = require("robot")
local sides = require("sides")

local function placeSupportBlock(block, tool)
  gps.moveTo(config.alvearySupplyPos)
  for slot = 1, inventory.getInventorySize(sides.down) do
    local item = inventory.getStackInSlot(sides.down, slot)
    if item ~= nil then
      if item.label == block then
        robot.select(1)
        inventory.suckFromSlot(sides.down, slot, 1)
      end
      if item.label == tool then
        robot.select(2)
        inventory.suckFromSlot(sides.down, slot, 1)
        inventory.equip()
      end
    end
  end
  gps.moveHome(config.alvearySupplyPos)
  
  gps.moveTo(config.supportBlockPos)
  robot.select(1)
  robot.placeDown()
  gps.moveHome(config.supportBlockPos)
  
  if block ~= "Block of Redstone" then
    gps.moveTo(config.transvectorPos)
    redstone.setOutput(sides.down, 15)
    redstone.setOutput(sides.down, 0)
    gps.moveHome(config.transvectorPos)
  end
  
  gps.moveTo(config.supportBlockPos)
  robot.select(1)
  robot.swingDown()
  gps.moveHome(config.supportBlockPos)
  
  gps.moveTo(config.alvearySupplyPos)
  robot.select(1)
  inventory.dropIntoSlot(sides.down, inv_utils.getFirstAvailableSlot(sides.down))
  robot.select(2)
  inventory.equip()
  inventory.dropIntoSlot(sides.down, inv_utils.getFirstAvailableSlot(sides.down))
  gps.moveHome(config.alvearySupplyPos)
end

local function getPurestDrone(droneType, secondaryType)
  --print("Retrieving a drone of type: ", droneType)
  robot.select(15)
  gps.moveTo(config.dronePos)
  for slot = 1, inventory.getInventorySize(sides.down) do
    local drone = inventory.getStackInSlot(sides.down, slot)
    if drone ~= nil and utils.getBeeType(drone) == droneType and not utils.isHybrid(drone) then
      inventory.suckFromSlot(sides.down, slot, 1)
      gps.moveHome(config.dronePos)
      return
    end
  end
  for slot = 1, inventory.getInventorySize(sides.down) do
    local drone = inventory.getStackInSlot(sides.down, slot)
    if drone ~= nil and utils.getBeeType(drone) == droneType then
      inventory.suckFromSlot(sides.down, slot, 1)
      gps.moveHome(config.dronePos)
      return
    end
  end
  for slot = 1, inventory.getInventorySize(sides.down) do
    local drone = inventory.getStackInSlot(sides.down, slot)
    if drone ~= nil and utils.getBeeType(drone) == secondaryType then
      inventory.suckFromSlot(sides.down, slot, 1)
      gps.moveHome(config.dronePos)
      return
    end
  end
  for slot = 1, inventory.getInventorySize(sides.down) do
    local drone = inventory.getStackInSlot(sides.down, slot)
    if drone ~= nil then
      inventory.suckFromSlot(sides.down, slot, 1)
      gps.moveHome(config.dronePos)
      return
    end
  end
  gps.moveHome(config.dronePos)
  error("Could not find a drone of type: ", droneType)
end

-- Assumes princess is in princessSlot
local function purify(originalPrincessType)
  inv_utils.acclimatize()
  local princess = inventory.getStackInInternalSlot(config.princessSlot)
  while (utils.getBeeType(princess) == originalPrincessType or inv_utils.getNumDrones(originalPrincessType) > 0) and (utils.isHybrid(princess) or utils.getBeeType(princess) ~= originalPrincessType) do
    alveary.toggleStabilizer(1)
    getPurestDrone(originalPrincessType, utils.getInactiveSpecies(princess))
    
    alveary.addBeePair()
    alveary.waitForQueenDeath()
    
    alveary.takeAllFromAlveary()
    inv_utils.pickUpLarvae()
    inv_utils.trashUselessBees()
    inv_utils.dropOffLarvae()
    inv_utils.dropOffDrones()
    
    inv_utils.acclimatize()
    princess = inventory.getStackInInternalSlot(config.princessSlot)
  end
  inv_utils.dropOffPrincess()
end

local function ensureSupply(droneType, minAmount, targetAmount)
  local numDrones = inv_utils.getNumDrones(droneType, true)
  --print("Found drones of type: ", droneType, numDrones)
  if numDrones >= minAmount then
    return
  end
  
  local princess = inventory.getStackInInternalSlot(config.princessSlot)
  if princess ~= nil and utils.getBeeType(princess) ~= droneType then
    robot.select(config.princessSlot)
    inventory.equip()
    inv_utils.getBestPrincess(droneType)
  elseif princess == nil then
    inv_utils.getBestPrincess(droneType)
  end
  
  while numDrones < targetAmount do
    alveary.toggleStabilizer(1)
    getPurestDrone(droneType, droneType)
    inv_utils.acclimatize()
    
    alveary.addBeePair()
    alveary.waitForQueenDeath()
    
    alveary.takeAllFromAlveary()
    inv_utils.pickUpLarvae()
    inv_utils.trashUselessBees()
    inv_utils.dropOffLarvae()
    inv_utils.dropOffDrones()
    
    purify(droneType)
    inv_utils.getBestPrincess(droneType)
    
    numDrones = inv_utils.getNumDrones(droneType, true)
  end
  if princess ~= nil and utils.getBeeType(princess) ~= droneType then
    inv_utils.dropOffPrincess()
    robot.select(config.princessSlot)
    inventory.equip()
  end
end

local function breedOnce(princessType, droneType, targetType, tempOverride, humidityOverride, biome)
  ensureSupply(droneType, config.minDrones, config.targetDroneCount)
  if inventory.getStackInInternalSlot(config.princessSlot) ~= nil then
    inv_utils.dropOffPrincess()
  end
  inv_utils.getBestPrincess(princessType)

  while utils.getBeeType(inventory.getStackInInternalSlot(config.princessSlot)) ~= targetType do
    ensureSupply(droneType, config.minDrones, config.targetDroneCount)
    
    local princess = inventory.getStackInInternalSlot(config.princessSlot)
    if utils.getBeeType(princess) == princessType then
      inv_utils.acclimatize(tempOverride, humidityOverride)
    else
      inv_utils.acclimatize()
    end

    if inv_utils.getNumDrones(targetType) > 0 then
      alveary.toggleStabilizer(1)
      inv_utils.getDrone(targetType, targetType)
    elseif utils.getBeeType(princess) ~= princessType then
      alveary.toggleStabilizer(1)
      inv_utils.getDrone(princessType, targetType)
    else
      alveary.toggleStabilizer(0)
      inv_utils.getDrone(droneType, targetType)
    end
    
    princess = inventory.getStackInInternalSlot(config.princessSlot)
    local drone = inventory.getStackInInternalSlot(config.droneSlot)

    if utils.getBeeType(princess) == princessType and biome ~= nil and utils.getBeeType(drone) ~= targetType and utils.getInactiveSpecies(princess) ~= targetType and utils.getInactiveSpecies(drone) ~= targetType then
      inv_utils.sendToBiome(biome)
      inv_utils.waitFromBiome()
    else
      alveary.addBeePair()
      alveary.waitForQueenDeath()
      alveary.takeAllFromAlveary()
      inv_utils.pickUpLarvae()
    end

    inv_utils.trashUselessBees()
    inv_utils.dropOffLarvae()
    inv_utils.dropOffDrones()
  end
end

local function isImportantSlot(slot)
  return slot == config.princessSlot or slot == config.droneSlot
end

local function trashHybrids()
  while true do
    robot.select(1)
    gps.moveTo(config.dronePos)
    local stackCount = 0
    for slot = inventory.getInventorySize(sides.down), 1, -1 do
      local drone = inventory.getStackInSlot(sides.down, slot)
      if drone ~= nil and utils.isDrone(drone) and utils.isHybrid(drone) then
        inventory.suckFromSlot(sides.down, slot)
        stackCount = stackCount + 1
      end
      if stackCount >= 5 then
        break
      end
    end
    gps.moveHome(config.dronePos)
    gps.moveTo(config.trashPos)
    for slot = 1, robot.inventorySize() do
      local drone = inventory.getStackInInternalSlot(slot)
      if not isImportantSlot(slot) and drone ~= nil and utils.isDrone(drone) and utils.isHybrid(drone) then
        robot.select(slot)
        inventory.dropIntoSlot(sides.down, 1)
      end
    end
    gps.moveHome(config.trashPos)
    if stackCount == 0 then
      break
    end
  end
end

return {
  breedOnce = breedOnce,
  ensureSupply = ensureSupply,
  purify = purify,
  getPurestDrone = getPurestDrone,
  trashHybrids = trashHybrids,
  placeSupportBlock = placeSupportBlock
}
