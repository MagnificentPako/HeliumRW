local old = {
  ["dofile"] = dofile
}

local function catchError(func)
  local ok,err = pcall(func)
  if(not ok) then error(err,4) end
end

--[[
function loadfile(path,env)
  local env = env or _ENV
  local handle = fs.open(path,"r")
  local c = handle.readAll()
  local f = load(c,path,nil,env)
  handle.close()
  return f
end
--]]
local function _dofile(path,reqenv)
  local reqenv = reqenv or _ENV
  if(not fs.exists(path)) then
    if(fs.exists(fs.combine(path,"")..".lua")) then
      local ok,err = loadfile(fs.combine(path,"")..".lua",reqenv)
      if(not ok) then error(err) end
      return ok(path)
    end
    error("File not found. ")
  else
    local ok,err = loadfile(path,reqenv)
    if(not ok) then error(err) end
    return ok(path)
  end
end

local function _require(path,reqenv)
  local reqenv = reqenv or _ENV
  local pa = path
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
      return _dofile(p,reqenv)
    end
  end
  return _dofile(path,reqenv)
end

function dofile(path)
  local cont
  catchError(function() cont = _dofile(path) end)
  return cont
end

function require(path,reqenv)
  local cont
  catchError(function()
     cont = _require(path,reqenv)
    end)
  return cont
end
