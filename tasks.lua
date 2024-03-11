
tasks = {}

local function createTask(fn, ...)
  table.insert(tasks, {fn = fn, args = {...}})
end

local function createPriorityTask(fn, ...)
  table.insert(tasks, 1, {fn = fn, args = {...}})
end

local function executeTask()
  if #tasks ~= 0 then
    local task = table.remove(tasks, 1)
    task.fn(table.unpack(task.args))
  end
end

return {
  createTask = createTask,
  createPriorityTask = createPriorityTask,
  executeTask = executeTask
}