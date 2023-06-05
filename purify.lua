
local breed = require("breed")
local inv_utils = require("inv_utils")

local targetType = ...
local princessType = inv_utils.getBestPrincess(targetType)
local droneType = targetType

print("Purify", targetType)
breed.purify(targetType)
print("Trash Hybrids")
breed.trashHybrids()
