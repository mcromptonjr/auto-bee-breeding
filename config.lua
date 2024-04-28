
local JSON = require("JSON")
local io = require("io")

local pickaxeName = "§fPickaxe"
local wrenchName = "Wrench"

local mutation_json = ""
for line in io.lines("mutations.json") do
  mutation_json = mutation_json .. line
end

function convertName(species)
  if species == "Thaumic Shards" then
    return "Thaumiumshard"
  end
  if species == "Wither" then
    return "Sparkeling"
  end
  local name = string.gsub(species, "[^a-zA-Z]", "")
  name = string.lower(name)
  
  return string.upper(string.sub(name, 1, 1)) .. string.sub(name, 2)
end

local foundationRegex = "Requires (.*) as a foundation%."
local biomeRegex = "Required Biome (.*)"
local biomeRegex2 = "Occurs within a (.*) biome%."
local dimensionRegex = "Required Dimension (.*)"
local temperatureRegex = "Requires (.*) temperature%."
local temperatureRegex2 = "Requires temperature between (.*) and .*%."
local humidityRegex = "Requires (.*) humidity%."

local regularExps = { 
  {desc = "support", regex = foundationRegex},
  {desc = "biome", regex = biomeRegex},
  {desc = "biome", regex = biomeRegex2},
  {desc = "biome", regex = dimensionRegex},
  {desc = "overrideTemp", regex = temperatureRegex},
  {desc = "overrideTemp", regex = temperatureRegex2},
  {desc = "overrideHumidity", regex = humidityRegex},
}

local mutations = JSON:decode(mutation_json)
local beeTree = {}
for i,mutation in ipairs(mutations.data.beeMutations) do
  local child = convertName(mutation.offspring.specie)
  local parentA = convertName(mutation.parentA.specie)
  local parentB = convertName(mutation.parentB.specie)
  local subTree = {parentA, parentB}
  local biome = nil
  local support = nil
  for i,requirement in ipairs(mutation.descriptions) do
    for _,re in ipairs(regularExps) do
      local s, e, group = string.find(requirement.description, re.regex)
      if s ~= nil then
        subTree[re.desc] = group
      end
    end
  end
  beeTree[child] = subTree
end

local mutatronSpecialBees = {
  requirements = {"Leporine", "Merry", "Tipsy", "Tricky", "Chad", "Americium", "Kevlar", "Drake"}, 
  disabled = {["Cosmicneutronium"] = true, ["Infinitycatalyst"] = true, ["Infinity"] = true, ["Indium"] = true}
}

local config = {
  beeTree = beeTree,
  mutatronSpecialBees = mutatronSpecialBees,

  acclimatizeSleepTime = 10, -- In seconds

  alvearySlot = 1,
  princessSlot = 16,
  droneSlot = 15,

  droneName = "Forestry:beeDroneGE",
  princessName = "Forestry:beePrincessGE",
  queenName = "Forestry:beeQueenGE",
  larvaeName = "Forestry:beeLarvaeGE",
  pickaxeName = pickaxeName,
  wrenchName = wrenchName,
  
  alvearyTempPos = { 
                    {pos = {0, 1, 0}, dir = {0, 0, 1}},
                    {pos = {-2, 1, 2}, dir = {1, 0, 0}},
                    {pos = {1, 1, 0}, dir = {0, 0, 1}},
                    {pos = {2, 1, 2}, dir = {-1, 0, 0}}
                   },
  alvearyDryPos = {
                     {pos = {0, 0, 0}, dir = {0, 0, 1}},
                     {pos = {1, 0, 0}, dir = {0, 0, 1}}
                   },
  alvearyDampPos = {
                     {pos = {2, 0, 2}, dir = {-1, 0, 0}},
                     {pos = {-2, 0, 2}, dir = {1, 0, 0}}
                   },
  alvearyStabPos = {
                     {pos = {-1, 1, 0}, dir = {0, 0, 1}}
                   },
  biomeFinishPos = {-3, 2, 0},
  biomePos = {
    ["Venus"] = {-3, 2, 1},
    ["End"] = {-3, 2, 2},
    ["Hellish"] = {-3, 2, 3},
    ["Ignoble"] = {-3, 2, 4},
  },
  biomeDir = {-1, 0, 0},
  
  minDrones = 8,
  targetDroneCount = 16,
  
  denylistEffects = {["Radioactive"] = true, ["Radioact."] = true},
  
  enableAcclimatizeAlveary = false,
  enableMutatron = true,
  
  locs = {
    ["Home"] = {pos = {0, 0, 0}, dir = {0, 0, 1}},
    ["AlvearyDropoff"] = {pos = {0, 2, 0}, dir = {0, 0, 1}},
    ["Acclimatizer"] = {pos = {-4, 1, 4}, dir = {0, -1, 0}},
    ["AcclimatizerResult"] = {pos = {-4, 1, 5}, dir = {0, -1, 0}},
    ["InProgressPrincess"] = {pos = {-4, 1, 0}, dir = {0, -1, 0}},
    ["PrincessSupply"] = {pos = {-4, 1, 1}, dir = {0, -1, 0}},
    ["DroneSupply"] = {pos = {-4, 1, 2}, dir = {0, -1, 0}},
    ["LarvaeDropoff"] = {pos = {-4, 1, -1}, dir = {0, -1, 0}},
    ["LarvaeOutput"] = {pos = {-1, 0, 0}, dir = {0, -1, 0}},
    ["Trash"] = {pos = {-4, 1, -2}, dir = {0, -1, 0}},
    ["ScannerDropoff"] = {pos = {-4, 1, 3}, dir = {0, -1, 0}},
    ["AlvearySupply"] = {pos = {1, 1, -1}, dir = {0, -1, 0}},
    ["Transvector"] = {pos = {-2, 0, -1}, dir = {0, 0, -1}},
    ["SupportBlock"] = {pos = {-2, 2, -2}, dir = {0, -1, 0}},
    ["Mutatron"] = {pos = {-4, 1, 6}, dir = {0, -1, 0}}
  },

  roomBounds = {{-5, -1, -3}, {5, 7, 7}},
  alvearyBounds = {{-1, 0, 1}, {1, 3, 3}},
  
  obstacles = {},
  
  mutations = mutations,
}

config.biomePos["None"] = config.biomeFinishPos

for x = config.alvearyBounds[1][1], config.alvearyBounds[2][1] do
  for y = config.alvearyBounds[1][2], config.alvearyBounds[2][2] do
    for z = config.alvearyBounds[1][3], config.alvearyBounds[2][3] do
      table.insert(config.obstacles, {x, y, z})
    end
  end
end

for k,v in pairs(config.locs) do
  local obstacle = {v.pos[1] + v.dir[1], v.pos[2] + v.dir[2], v.pos[3] + v.dir[3]}
  table.insert(config.obstacles, obstacle)
end
for k,v in pairs(config.biomePos) do
  local obstacle = {v[1] + config.biomeDir[1], v[2] + config.biomeDir[2], v[3] + config.biomeDir[3]}
  table.insert(config.obstacles, obstacle)
end

table.insert(config.obstacles, {-3, 0, 4})
table.insert(config.obstacles, {-3, 0, 5})
table.insert(config.obstacles, {-3, 0, 0})
table.insert(config.obstacles, {-3, 0, 1})
table.insert(config.obstacles, {-3, 0, 2})
table.insert(config.obstacles, {-3, 0, 3})
table.insert(config.obstacles, {-3, 0, -1})
table.insert(config.obstacles, {-3, 0, 6})

return config
