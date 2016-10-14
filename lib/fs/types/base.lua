local BaseFS = class "BaseFS"

function BaseFS:initialize()
  self._middleware = {}
  self._middleware_id = 0
end

function BaseFS:list(path)
  return {}
end

function BaseFS:find(wildcard)
  return {}
end

function BaseFS:exists(path)
    return false
end

function BaseFS:isDir(path)
  return false
end

function BaseFS:isReadOnly(path)
  return false
end

function BaseFS:getDir(path)
  return ""
end

function BaseFS:getName(path)
  return ""
end

function BaseFS:getSize(path)
  return 0
end

function BaseFS:getDrive(path)
  return ""
end

function BaseFS:getFreeSpace(path)
  return 0
end

function BaseFS:makeDir(path)
  return false
end

function BaseFS:move(path,path)
  return false
end

function BaseFS:copy(path,path)
  return false
end

function BaseFS:delete(path)
  return false
end

function BaseFS:combine(path,localpath)
  return fs.combine(path,localpath)
end

function BaseFS:open(path,mode)
  return setmetatable({},{__index=function() return function() end end})
end

function BaseFS:complete(path,location)
  return {}
end

function BaseFS:addMiddleware(obj)
  self._middleware_id = self._middleware_id+1
  self._middleware[self._middleware_id] = obj
  return self._middleware_id
end

function BaseFS:removeMiddleware(id)
  self._middleware[id] = nil
end

function BaseFS:makeLegacy()
  local legacy = {}
  for k,v in pairs(fs) do
    legacy[k] = function(...) return self[k](self,...) end
  end
  legacy.legacy = true
  return legacy
end

function BaseFS:applyMiddleware(typ,txt)
  local txt = txt
  if(#self._middleware == 0) then return txt end
  switch(typ) {
    ["read"] = function()
      for k,v in pairs(self._middleware) do
        txt = v:beforeRead(txt)
      end
    end;
    ["save"] = function()
      for k,v in pairs(self._middleware) do
        txt = v:beforeSave(txt)
      end
    end;
  }
  return txt
end

return BaseFS
