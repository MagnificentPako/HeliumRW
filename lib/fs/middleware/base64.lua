local Base64 = require "lib.base64"
local MiddlewareBase = require "lib.fs.middleware.base"

local Base64Middleware = class("Base64Middleware", MiddlewareBase)

function Base64Middleware:beforeRead(txt)
  local cont = {}
  for _,v in pairs(txt) do
    cont[#cont+1] = Base64.decode(v)
  end
  return cont
end

function Base64Middleware:beforeSave(txt)
  local cont = {}
  for _,v in pairs(txt) do
    cont[#cont+1] = Base64.encode(v)
  end
  return cont
end

return Base64Middleware
