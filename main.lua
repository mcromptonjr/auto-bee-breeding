
local breed = require("breed")
local config = require("config")
local inv_utils = require("inv_utils")

-- DONE Pipe in mutation stuff
-- DONE (NEED TESTING) Add in code to ensure X supply of drones
-- Test error function
-- DONE Comb isnt being trashed
-- DONE Add while not robot.forward() to the move functions
-- DONE Change logging to be less spammy, add timestamps if possible
-- DONE P0: Purify princesses
-- DONE ensureSupply should be a supply of pure drones
-- DONE Once we have enough of a pure supply, delete hybrid drones
-- DONE Transvector dislocator for bees that need certain blocks under alveary
-- DONE Set up alvearies in target biomes and temperature locations (Hellish, Icy, Forest)
-- DONE Teleport bee pairs to these locations
-- DONE Add overrides to config
-- DONE Add support block to config
-- DONE Get Drones that have the target type as the inactive type (preferrably)
-- DONE Change number of heaters to target "Warm" vs "Hot"

-- Magic shit
-- Advanced Alchemical Furnace (Multiblock)
-- Automate bloodmagic alchemy
-- Infusion ritual robot
-- Teleposers for eugene

local lastTool = config.pickaxeName

local tasks = inv_utils.calculateBeeBreedTasks()

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
    local biome = v.biome
    
    local support = v.support
    local tool = v.tool == nil and config.pickaxeName or v.tool
    
    print("Support: ", support)
    breed.placeSupportBlock(support, lastTool)
    lastTool = tool ~= nil and tool or lastTool
    print("Breed: ", targetType)
    breed.breedOnce(princessType, droneType, targetType, overrideTemp, overrideHumidity, biome)
    print("Purify")
    breed.purify(targetType)
    print("Build Supply")
    breed.ensureSupply(targetType, config.minDrones, config.targetDroneCount)
    inv_utils.dropOffPrincess()
    print("Trash Hybrids")
    breed.trashHybrids()
  end
end
