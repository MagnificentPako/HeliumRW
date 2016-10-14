local Middleware = class "FSMiddleware"

function Middleware:beforeRead(txt)
  return txt
end

function Middleware:beforeSave(txt)
  return txt
end

return Middleware
