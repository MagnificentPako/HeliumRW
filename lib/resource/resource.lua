local JSON = require "lib.json"
local Resource = class "Resource"

function Resource:initialize()
  self.resources = {}
  self.lookup = {}
end

function Resource:__index(k)
  if(k:match("get[A-Z][a-z]+")) then
    local varName = k:match("get([A-Z][a-z]+)")
    varName = varName:sub(1,1):lower()..varName:sub(2,#varName)
    if(self.lookup[varName]) then
      return function()
        return self.resources[varName]
      end
    end
  elseif(k:match("set[A-Z][a-z]+")) then
    local varName = k:match("(set[A-Z][a-z]+)")
    varName = varName:sub(1,1):lower()..varName:sub(2,#varName)
    if(self.lookup[varName]) then
      return function(val)
        self.resources[varName] = val
      end
    end
  end
end

return Resource
