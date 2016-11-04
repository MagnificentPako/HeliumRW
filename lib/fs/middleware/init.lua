local ImportProxy = require "lib.import_proxy"
local proxy = ImportProxy:new()

proxy:add("BaseMiddleware", "lib.fs.middleware.base")
proxy:add("Base64Middleware", "lib.fs.middleware.base64")

return proxy:convert()
