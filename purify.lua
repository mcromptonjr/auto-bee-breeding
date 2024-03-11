
local breed = require("breed")
local inv_utils = require("inv_utils")
local config = require("config")
local utils = require("utils")
local gps = require("gps")

local args = ...
local targetTypes = utils.strsplit(args, ",")
for _, targetType in ipairs(targetTypes) do
  local princessType = inv_utils.getBestPrincess(targetType)
  local droneType = targetType

  config.beeTree[targetType] = {targetType, targetType}

  print("Purify", targetType)
  breed.purify(targetType)
  print("Trash Hybrids")
  breed.trashHybrids()
end
gps.move(config.locs["Home"].pos)
gps.turn(config.locs["Home"].dir)
