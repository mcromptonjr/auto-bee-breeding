
local breed = require("breed")
local config = require("config")
local inv_utils = require("inv_utils")
local utils = require("utils")
local inventory = require("component").inventory_controller
local computer = require("computer")
local gps = require("gps")

local lastTool = config.pickaxeName

local args = ...
local targetTypes = utils.strsplit(args, ",")

for i,targetType in ipairs(targetTypes) do
  local tasks = inv_utils.calculateBeeBreedTasks(targetType)

  for task = 1, #tasks do
    for k, v in pairs(tasks[task]) do
      print(string.format("%s=%s+%s", k, v[1], v[2]))
    end
  end

  for task = 1, #tasks do
    for k, v in pairs(tasks[task]) do
      local princessType = v[1]
      local droneType = v[2]
      local targetType = k
      local overrideTemp = v.overrideTemp
      local overrideHumidity = v.overrideHumidity
      if config.enableMutatron and not config.mutatronSpecialBees[v.targetType] then
        v.biome = nil
        v.support = nil
      end
      local supportBiome = (v.biome ~= nil) and v.biome or "None"
      local biome = v.biome
      local needsHumanHelp = v.needsHumanHelp
      
      local support = v.support
      local tool = v.tool == nil and config.pickaxeName or v.tool
      
      print("Support: ", support)
      breed.placeSupportBlock(support, lastTool, config.biomePos[supportBiome])
      lastTool = tool ~= nil and tool or lastTool
      
      local firstSlot = inventory.getStackInInternalSlot(1)
      while needsHumanHelp and (firstSlot == nil or firstSlot.label ~= "Stone") do
        computer.beep("...---...")
        os.execute("sleep " .. config.acclimatizeSleepTime)
        firstSlot = inventory.getStackInInternalSlot(1)
      end
      
      print("Breed: ", targetType)
      breed.breedOnce(princessType, droneType, targetType, overrideTemp, overrideHumidity, biome)
      print("Purify")
      breed.purify(targetType)
      print("Build Supply")
      breed.ensureSupply(targetType, config.minDrones, config.targetDroneCount)
      inv_utils.dropOffPrincess()
      print("Trash Hybrids")
      breed.trashHybrids()
      gps.move(config.locs["Home"].pos)
      gps.turn(config.locs["Home"].dir)
    end
  end
end

gps.move(config.locs["Home"].pos)
gps.turn(config.locs["Home"].dir)
