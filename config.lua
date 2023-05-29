
local pickaxeName = "§fPickaxe"
local wrenchName = "Wrench"

return {
  --beeTree = {
  --  ["Gold"] = {"Lead", "Copper", support="Block of Gold", tool=pickaxeName, overrideTemp="Hot", overrideHumidity="Normal"},
  --  ["Redstone"] = {"Industrious", "Demonic", support="Block of Redstone", tool=pickaxeName},
  --  ["Glowstone"] = {"Redstone", "Gold"},
  --  ["Sunnarium"] = {"Glowstone", "Gold", support="Superconducting Coil Block", tool=wrenchName}
  --},
  -- Monastic, Demonic, Ender, Imperial, Modest, Sinister, Coal, Steadfast, Valiant, Copper, Tin, Redstone
  beeTree = {
    --["Naquadah"] = {"Plutonium", "Iridium", support="Block of Naquadah"},
    --["Plutonium"] = {"Uranium", "Emerald", support="Block of Plutonium 239"},
    ["Iridium"] = {"Tungsten", "Platinum", support="Block of Iridium"},
    --["Uranium"] = {"Avenging", "Platinum", support="Block of Uranium 238"},
    ["Emerald"] = {"Olivine", "Diamond", support="Block of Emerald"},
    ["Tungsten"] = {"Heroic", "Manganese", support="Block of Tungsten"},
    ["Platinum"] = {"Diamond", "Chrome", support="Block of Nickel"},
    --["Avenging"] = {"Vengeful", "Vindictive"},
    --["Vengeful"] = {"Demonic", "Vindictive"},
    --["Vindictive"] = {"Monastic", "Demonic"},
    ["Olivine"] = {"Certus", "Ender"},
    ["Certus"] = {"Hermitic", "Lapis", support="Certus Quartz Block"},
    ["Hermitic"] = {"Monastic", "Secluded"},
    ["Lapis"] = {"Demonic", "Imperial", support="Lapis Lazuli Block"},
    ["Secluded"] = {"Monastic", "Austere"},
    ["Austere"] = {"Modest", "Frugal", overrideTemp="Hot", overrideHumidity="Arid"},
    ["Frugal"] = {"Modest", "Sinister", overrideTemp="Hot", overrideHumidity="Arid"},
    ["Diamond"] = {"Certus", "Coal", support="Block of Diamond"},
    ["Heroic"] = {"Steadfast", "Valiant", biome="Forest"},
    ["Manganese"] = {"Titanium", "Aluminium", support="Block of Manganese"},
    ["Aluminium"] = {"Nickel", "Zinc", support="Block of Aluminum"},
    ["Nickel"] = {"Iron", "Copper", support="Block of Nickel"},
    ["Zinc"] = {"Iron", "Tin", support="Block of Zinc"},
    ["Iron"] = {"Tin", "Copper", support="Block of Iron"},
    ["Titanium"] = {"Redstone", "Aluminium", support="Block of Titanium"},
    ["Chrome"] = {"Titanium", "Ruby", support="Block of Chrome"},
    ["Ruby"] = {"Redstone", "Diamond", support="Block of Ruby"}
  },

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

  accPos = {-4, 1, 4},
  accResPos = {-5, 1, 4},
  progPrincessPos = {0, 1, 4},
  princessPos = {-1, 1, 4},
  dronePos = {-2, 1, 4},
  larvaePos = {0, 0, 1},
  larvaeDronePos = {1, 1, 4},
  trashPos = {2, 1, 4},
  scannerPos = {-3, 1, 4},
  alvearySupplyPos = {1, 1, -1},
  supportBlockPos = {1, 1, 2},
  transvectorPos = {2, 1, 2},
  
  alvearyTempPos = {
                    {0, 1, 0, 0},
                    {-2, 1, 2, 3},
                    {0, 1, -1, 0},
                    {-2, 1, -2, 1}
                   },
  alvearyDryPos = {
                     {0, 0, 0, 0},
                     {0, 0, -1, 0}
                   },
  alvearyDampPos = {
                     {-2, 0, 2, 3},
                     {-2, 0, -2, 1}
                   },
  alvearyStabPos = {
                     {0, 1, 1, 0}
                   },
  biomePos = {
    ["Forest"] = {-1, 1, 4}
  },
  biomeFinishPos = {0, 1, 4},
  
  minDrones = 8,
  targetDroneCount = 16
}
