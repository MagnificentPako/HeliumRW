local Ram = require "lib.fs.types.ram"
local Wrapper = require "lib.fs.types.wrapper"
local Container = class "Container"

function Container:initialize()
  local wrapper = Wrapper:new(fs)
  self._system = Ram:new(wrapper)
end

function Container:load(path)
  self._system:loadFile(path)
end

function Container:save(path)
  self._system:saveFile(path)
end

function Container:import(path)
  self._system:import(path)
end

return Container
