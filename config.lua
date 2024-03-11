
local pickaxeName = "§fPickaxe"
local wrenchName = "Wrench"

-- Centauri Bees
-- Silverfish

-- Iridium, Lead, Enceladus, Saturn, Naquadria, Desh

local config = {
  beeTree = {
    ["Salt"] = {"Clay", "Aluminium"}
    --["Ash"] = {"Coal", "Clay"},
    --["Tainted"] = {"Thaumiumdust", "Thaumiumshard"},
    --["Silverfish"] = {"Ectoplasma", "Stardust"},
    --["Ectoplasma"] = {"Ender", "Enddust"},
    --["Stardust"] = {"Ender", "Zinc"}
    --["Centauri"] = {"Makemake", "Desh"},
    --["Makemake"] = {"Pluto", "Naquadria"},
    --["Pluto"] = {"Neptune", "Plutonium"},
    --["Neptune"] = {"Uranus", "Oriharukon"},
    --["Uranus"] = {"Saturn", "Trinium"},
    --["Trinium"] = {"Enceladus", "Iridium"},
    --["Oriharukon"] = {"Lead", "Oberon"},
    --["Oberon"] = {"Uranus", "Iridium"}
  },
  
  --    ["Naga"] = {"Eldritch", "Imperial"}
  --    ["Desh"] = {"Mars", "Titanium", biome="Hellish"},
--    ["Frigid"] = {"Wintry", "Diligent"},
--    ["Ledox"] = {"Callisto", "Lead", biome="End"},
--    ["Callisto"] = {"Jupiter", "Frigid", biome="Hellish"}
  
  --beeTree = {
  --  ["Salismundus"] = {"Thaumiumdust", "Thaumiumshard", biome="Icy"},
  --  ["Thaumiumdust"] = {"Ignis", "Edenic", biome="Icy"},
  --  ["Thaumiumshard"] = {"Thaumiumdust", "Aqua", biome="Icy"},
  --  ["Ignis"] = {"Firey", "Firey", support="Fire Crystal Cluster"},
  --  ["Edenic"] = {"Exotic", "Tropical"},
  --  ["Aqua"] = {"Watery", "Watery", support="Water Crystal Cluster"},
  --  ["Exotic"] = {"Austere", "Tropical"},
  --  ["Firey"] = {"Supernatural", "Ethereal", needsHumanHelp=true},
  --  ["Watery"] = {"Supernatural", "Ethereal", needsHumanHelp=true}
  --},

  --beeTree = {
  --  ["Endshard"] = {"Nethershard", "Enddust", biome="Icy", support="Block of Endereye"},
  --  ["Nethershard"] = {"Chaos", "Fire", support="Block of Nether Star"},
  --  ["Chaos"] = {"Order", "Fire", biome="Icy", support="Entropy Crystal Cluster"},
  --  ["Order"] = {"Earth", "Fire", biome="Icy", support="Order Crystal Cluster"},
  --  ["Earth"] = {"Water", "Fire", overrideTemp="Warm", support="Earth Crystal Cluster"},
  --  ["Water"] = {"Fire", "Air", biome="Icy", support="Water Crystal Cluster"},
  --  ["Fire"] = {"Supernatural", "Air", biome="Hellish"},
  --  ["Air"] = {"Supernatural", "Windy", overrideTemp="Hot", support="Air Crystal Cluster"},
  --  ["Enddust"] = {"Ender", "Stainlesssteel", biome="End"},
  --  ["Stainlesssteel"] = {"Chrome", "Steel", support="Block of Stainless Steel"},
  --  ["Steel"] = {"Iron", "Coal", support="Block of Steel", overrideTemp="Hot"}
  --},
  --beeTree = {
  --  ["Space"] = {"Industrious", "Heroic", biome="Icy"},
  --  ["Moon"] = {"Space", "Clay", biome="Moon"},
  --  ["Mars"] = {"Moon", "Iron", biome="Mars"}
  --},
  --beeTree = {
  --  ["Gold"] = {"Lead", "Copper", support="Block of Gold", tool=pickaxeName, overrideTemp="Hot", overrideHumidity="Normal"},
  --  ["Redstone"] = {"Industrious", "Demonic", support="Block of Redstone", tool=pickaxeName},
  --  ["Glowstone"] = {"Redstone", "Gold"},
  --  ["Sunnarium"] = {"Glowstone", "Gold", support="Superconducting Coil Block", tool=wrenchName}
  --},
  -- Monastic, Demonic, Ender, Imperial, Modest, Sinister, Coal, Steadfast, Valiant, Copper, Tin, Redstone
  --beeTree = {
  --  ["Naquadah"] = {"Plutonium", "Iridium", support="Block of Naquadah"},
  --  ["Plutonium"] = {"Uranium", "Emerald", support="Block of Plutonium 239"},
  --  ["Iridium"] = {"Tungsten", "Platinum", support="Block of Iridium"},
  --  ["Uranium"] = {"Avenging", "Platinum", support="Block of Uranium 238"},
  --  ["Emerald"] = {"Olivine", "Diamond", support="Block of Emerald"},
  --  ["Tungsten"] = {"Heroic", "Manganese", support="Block of Tungsten"},
  --  ["Platinum"] = {"Diamond", "Chrome", support="Block of Nickel"},
  --  ["Avenging"] = {"Vengeful", "Vindictive"},
  --  ["Vengeful"] = {"Monastic", "Vindictive"},
  --  ["Vindictive"] = {"Monastic", "Demonic"},
  --  ["Olivine"] = {"Certus", "Ender"},
  --  ["Certus"] = {"Hermitic", "Lapis", support="Certus Quartz Block"},
  --  ["Hermitic"] = {"Monastic", "Secluded"},
  --  ["Lapis"] = {"Demonic", "Imperial", support="Lapis Lazuli Block"},
  --  ["Secluded"] = {"Monastic", "Austere"},
  --  ["Austere"] = {"Modest", "Frugal", overrideTemp="Hot", overrideHumidity="Arid"},
  --  ["Frugal"] = {"Modest", "Sinister", overrideTemp="Hot", overrideHumidity="Arid"},
  --  ["Diamond"] = {"Certus", "Coal", support="Block of Diamond"},
  --  ["Heroic"] = {"Steadfast", "Valiant", biome="Forest"},
  --  ["Manganese"] = {"Titanium", "Aluminium", support="Block of Manganese"},
  --  ["Aluminium"] = {"Nickel", "Zinc", support="Block of Aluminum"},
  --  ["Nickel"] = {"Iron", "Copper", support="Block of Nickel"},
  --  ["Zinc"] = {"Iron", "Tin", support="Block of Zinc"},
  --  ["Iron"] = {"Tin", "Copper", support="Block of Iron"},
  --  ["Titanium"] = {"Redstone", "Aluminium", support="Block of Titanium"},
  --  ["Chrome"] = {"Titanium", "Ruby", support="Block of Chrome"},
  --  ["Ruby"] = {"Redstone", "Diamond", support="Block of Ruby"}
  --},

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
                     {pos = {-1, 1, 1}, dir = {0, 0, 1}}
                   },
  biomeFinishPos = {-3, 2, 0},
  biomePos = {
    ["Icy"] = {-3, 2, 1},
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
  
  obstacles = {}
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
