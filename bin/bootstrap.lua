local CoroutineManager = require "lib.coroutine_manager"
local manager = CoroutineManager:new()

local handle = fs.open("bin/shell","r")
local content = handle.readAll()
handle.close()
local ok, err = load(content, "shell", nil, getfenv())
if(not ok) then print(err) end

local function loadFile(path)
  local handle = fs.open(path,"r")
  local content = handle.readAll()
  handle.close()
  local ok, err = load(content, path, nil, getfenv())
  if(not ok) then print(err) end
  return coroutine.create(ok)
end

manager:addCoroutine(loadFile("bin/shell"))

manager:run()
