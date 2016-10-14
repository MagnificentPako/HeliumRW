local old = {
  ["dofile"] = dofile
}

local function catchError(func)
  local ok,err = pcall(func)
  if(not ok) then error(err) end
end

--[[
function loadfile(path,env)
  local env = env or _ENV
  local handle = fs.open(path,"r")
  local c = handle.readAll()
  local f = load(c,nil,"s",env)
  handle.close()
  return f
end
--]]
local function _dofile(path)
  if(not fs.exists(path)) then
    if(fs.exists(fs.combine(path,"")..".lua")) then
      return old["dofile"](fs.combine(path,"")..".lua")
    end
    error("File not found. ")
  else
    return old["dofile"](path)
  end
end

local function _require(path)
  if(path:sub(#path-4,#path) == ".lua") then
    path = path:sub(#path-4,#path)
    path = path:gsub("%.","/")
    path = path..".lua"
  else
    path = path:gsub("%.","/")
  end

  if(fs.isDir(path)) then
    local p =fs.combine(path,"init.lua")
    if(fs.exists(p)) then
      return loadfile(p)(path)
    end
  else
    return dofile(path)
  end
end

function dofile(path)
  local cont
  catchError(function() cont = _dofile(path) end)
  return cont
end

function require(path)
  local cont
  catchError(function() cont = _require(path) end)
  return cont
end
