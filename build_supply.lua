
local breed = require("breed")
local inv_utils = require("inv_utils")
local config = require("config")

local targetType = ...

config.beeTree[targetType] = {targetType, targetType}

print("Build Supply", targetType)
breed.ensureSupply(targetType, config.minDrones, config.targetDroneCount)
print("Trash Hybrids")
breed.trashHybrids()
