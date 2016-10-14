local Wrapper = class("WrapperFS", require "lib.fs.types.base")

function Wrapper:initialize(parent)
  self._parent = parent or fs
end

function Wrapper:list(path)
  return self._parent.list(path)
end

function Wrapper:find(wildcard)
  return self._parent.find(wildcard)
end

function Wrapper:exists(path)
    return self._parent.exists(path)
end

function Wrapper:isDir(path)
  return self._parent.isDir(path)
end

function Wrapper:isReadOnly(path)
  return self._parent.isReadOnly(path)
end

function Wrapper:getDir(path)
  return self._parent.getDir(path)
end

function Wrapper:getName(path)
  return self._parent.getName(path)
end

function Wrapper:getSize(path)
  return self._parent.getSize(path)
end

function Wrapper:getDrive(path)
  return self._parent.getDrive(path)
end

function Wrapper:getFreeSpace(path)
  return self._parent.getFreeSpace(path)
end

function Wrapper:makeDir(path)
  return self._parent.makeDir(path)
end

function Wrapper:move(from,to)
  return self._parent.move(from,to)
end

function Wrapper:copy(from,to)
  return self._parent.copy(from,to)
end

function Wrapper:delete(path)
  return self._parent.delete(path)
end

function Wrapper:open(path,mode)
  return self._parent.open(path,mode)
end

function Wrapper:complete(path,location)
  return self._parent.complete(path,location)
end

return Wrapper
