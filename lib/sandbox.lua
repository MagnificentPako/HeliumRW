local RamFS = require "lib.fs.types.ram"
local WrapperFS = require "lib.fs.types.wrapper"
local baseDir = "/box"

local Sandbox = class "Sandbox"

function Sandbox:resetEnv()
  self._proxy = {}
  self._readOnly = {}
  local function indexResolver(t,k)
    if(self._readOnly[k]) then return self._readOnly[k] end
    return self._proxy[k] and self._proxy[k] or self._global[k]
  end

  local function newindexResolver(t,k,v)
    if(self._readOnly[k]) then return end
    self._proxy[k] = v
  end
  self._env = setmetatable({}, {__index = indexResolver, __newindex = newindexResolver, __metatable = false})

  function self._readOnly.getfenv(...)
    return getfenv(...) == self._global and self._env or getfenv(...)
  end

end

function Sandbox:initialize(name,global)
  self._name = name
  self._global = global
  if(not fs.exists(baseDir)) then fs.makeDir(baseDir) end
  if(not fs.exists(fs.combine(baseDir, name))) then fs.makeDir(fs.combine(baseDir, name)) end
  self:resetEnv()
  self._middleware = {}
  self._import = {}
  self._libs = {}
end

function Sandbox:addImport(f,t)
  table.insert(self._import, {from=f, to=t})
end

function Sandbox:addMiddleware(middle)
  table.insert(self._middleware, middle)
end

function Sandbox:addLib(p,n)
  table.insert(self._libs, {path=p, name=n})
end

function Sandbox:run(path, ...)
  self:resetEnv()

  local wrapper = WrapperFS:new(fs)
  local ram = RamFS:new(wrapper)
  for k,v in pairs(self._import) do
    print(inspect(v))
    ram:import(v.from,v.to,true)
  end

  for k,v in pairs(self._middleware) do
    ram:addMiddleware(v)
  end

  for k,v in pairs(self._libs) do
    self._env[v.name] = require(v.path, self._env)
  end

  ram:makeDir("persistent")
  self._env.fs = ram:makeLegacy()

  loadfile(path, self._env)(...)

  ram:export("persistent",fs.combine(baseDir, self._name),true)
end

return Sandbox
