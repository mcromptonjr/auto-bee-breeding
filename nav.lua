
local pq = require("priority_queue")
local config = require("config")

local function heuristic(start, dest)
  local extra = 1
  if start[1] == dest[1] or start[3] == dest[3] then
    extra = 0
  end
  return math.abs(dest[1] - start[1]) + math.abs(dest[2] - start[2]) + math.abs(dest[3] - start[3]) + extra
end

-- use table.sort(array, comparrison_function) to implement a shitty priority queue

local function encode(position)
  return string.char(position[1]+128, position[2]+128, position[3]+128)
end

local function decode(key)
  local position = {string.byte(key, 1, 3)}
  for i = 1, 3 do
    position[i] = position[i] - 128
  end
  
  return position
end

local obstacles = {}
for i,v in ipairs(config.obstacles) do
  obstacles[encode(v)] = true
end

local function getNeighbors(p)
  local neighbors = {}
  if not obstacles[encode({p[1]+1, p[2], p[3]})] then
    table.insert(neighbors, {p[1]+1, p[2], p[3]})
  end
  if not obstacles[encode({p[1]-1, p[2], p[3]})] then
    table.insert(neighbors, {p[1]-1, p[2], p[3]})
  end
  if not obstacles[encode({p[1], p[2]+1, p[3]})] then
    table.insert(neighbors, {p[1], p[2]+1, p[3]})
  end
  if not obstacles[encode({p[1], p[2]-1, p[3]})] and p[2]-1 >= 0 then
    table.insert(neighbors, {p[1], p[2]-1, p[3]})
  end
  if not obstacles[encode({p[1], p[2], p[3]+1})] then
    table.insert(neighbors, {p[1], p[2], p[3]+1})
  end
  if not obstacles[encode({p[1], p[2], p[3]-1})] then
    table.insert(neighbors, {p[1], p[2], p[3]-1})
  end
  return neighbors
end

local function d(current, neighbor, encoded_parent)
  local parent = {0, 0, 1}
  if encoded_parent ~= nil then
    parent = decode(encoded_parent)
  end
  
  if (current[1] == neighbor[1] and neighbor[1] == parent[1]) or (current [3] == neighbor[3] and neighbor[3] == parent[3]) then
    return 1
  end
  return 2
end

local function reconstruct_path(cameFrom, encoded_current)
  local total_path = {}
  while encoded_current ~= nil do
    table.insert(total_path, decode(encoded_current))
    encoded_current = cameFrom[encoded_current]
  end
  return total_path
end

local function a_star(start, dest)
  local infinity = 1000000000
  local start_score = heuristic(start, dest)
  local encode_start = encode(start)
  local encode_dest = encode(dest)
  
  local openSet = pq()
  openSet[encode(start)] = start_score
  
  local cameFrom = {}
  
  local gScore = {[encode_start] = 0}
  local fScore = {[encode_start] = start_score}
  
  while not openSet.empty() do
    local encoded_current = openSet.min()
    local current = decode(encoded_current)
    if encoded_current == encode_dest then
      return reconstruct_path(cameFrom, encoded_current)
    end
    
    openSet.remove(encoded_current)
    for i, neighbor in ipairs(getNeighbors(current)) do
      local encoded_neighbor = encode(neighbor)
      local d_value = d(current, neighbor, cameFrom[encoded_current])
      local tentative_gScore = gScore[encoded_current] + d_value
      if gScore[encoded_neighbor] == nil or tentative_gScore < gScore[encoded_neighbor] then
        cameFrom[encoded_neighbor] = encoded_current
        gScore[encoded_neighbor] = tentative_gScore
        fScore[encoded_neighbor] = tentative_gScore + heuristic(neighbor, dest)
        if openSet[encoded_neighbor] == nil then
          openSet[encoded_neighbor] = fScore[encoded_neighbor]
        end
      end
    end
  end
end

return {
  a_star = a_star,
  encode = encode,
  decode = decode
}
