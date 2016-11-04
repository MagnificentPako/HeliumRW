local ImportProxy = require "lib.import_proxy"
local proxy = ImportProxy:new()

proxy:add("BaseFS", "lib.fs.types.base")
proxy:add("RamFS", "lib.fs.types.ram")
proxy:add("WrapperFS", "lib.fs.types.wrapper")

return proxy:convert()
