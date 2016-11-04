local Config = class "Config"
local base
local function dotSplit(str)
  local fields, length = {},0
    str:gsub("[^%.]+", function(c)
    length = length + 1
    fields[length] = c
  end)
  return fields, length
end

function Config:initialize(name, callback)
  base = fs.exists("persistent") and "persistent/config" or "config"
  self._conf = {}
  self._name = name
  if(not fs.exists(base)) then
    fs.makeDir(base)
  end
  if(fs.exists(fs.combine(base,name..".json"))) then
    local handle = fs.open(fs.combine(base,name..".json"),"r")
    self._conf = JSON.parse(handle.readAll())
    handle.close()
  else
    local handle = fs.open(fs.combine(base,name..".json"),"w")
    handle.write(JSON.stringify{})
    handle.close()
    if(callback) then callback() end
  end
end

function Config:set(key,value)
  local f,l = dotSplit(key)
  local current = self._conf
  for k,v in pairs(f) do
    if(l == 1) then

    else
      if(k > l-1) then break end
      if(current[v] and type(current[v]) ~= "table") then error("Config malformed") end
      current[v] = current[v] or {}
      current = current[v]
    end

  end

  current[f[l]] = value
end

function Config:get(key,value)
  local f,l = dotSplit(key)
  local current = self._conf
  for k,v in pairs(f) do
    if(k > l-1) then break end
    if(current[v] and type(current[v]) ~= "table") then error("Config malformed") end
    current = current[v]
  end
  return current[f[l]]
end

function Config:save()
  local handle = fs.open(fs.combine(base,self._name..".json"),"w")
  handle.write(JSON.stringify(self._conf):gsub(",",",\n"):gsub("}","}\n"):gsub(":",": "):gsub("{", "{\n"):gsub("}\n,","},"))
  handle.close()
end

return Config
