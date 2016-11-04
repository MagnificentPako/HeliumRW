local ImportProxy = require "lib.import_proxy"
local proxy = ImportProxy:new()

proxy:add("Base64", "lib.base64")
proxy:add("Config", "lib.config")
proxy:add("Container", "lib.container")
proxy:add("Cron", "lib.cron")
proxy:add("JSON", "lib.json")
proxy:add("Sandbox","lib.sandbox")
proxy:add("semver", "lib.semver")
proxy:add("SHA", "lib.sha")
proxy:add("switch", "lib.switch")
proxy:add("CoroutineManager", "lib.coroutine_manager")

return proxy:convert()
