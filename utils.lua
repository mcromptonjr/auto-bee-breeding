
local config = require("config")

local function getBeeType(bee)
  return bee.individual.displayName
end

local function getActiveSpecies(bee)
  return bee.individual.active.species.name
end

local function getInactiveSpecies(bee)
  return bee.individual.inactive.species.name
end

local function isPrincess(bee)
  return bee.name == config.princessName
end

local function isDrone(bee)
  return bee.name == config.droneName
end

local function isQueen(bee)
  return bee.name == config.queenName
end

local function isLarvae(bee)
  return bee.name == config.larvaeName
end

local function isHybrid(bee)
  return getActiveSpecies(bee) ~= getInactiveSpecies(bee)
end

local function listUsefulBeeTypes()
  local usefulTypes = {}
  for k, v in pairs(config.beeTree) do
    usefulTypes[k] = true
    usefulTypes[v[1]] = true
    usefulTypes[v[2]] = true
  end
  
  return usefulTypes
end

function copyTable(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function tableLength(T)
   local count = 0
   for _ in pairs(T) do count = count + 1 end
   return count
end

return {
  getBeeType = getBeeType,
  isPrincess = isPrincess,
  isDrone = isDrone,
  isQueen = isQueen,
  isLarvae = isLarvae,
  isHybrid = isHybrid,
  copyTable = copyTable,
  tableLength = tableLength,
  listUsefulBeeTypes = listUsefulBeeTypes,
  getActiveSpecies = getActiveSpecies,
  getInactiveSpecies = getInactiveSpecies
}
