--This class is the "mediator" between the user and log providers
--It gives easier access and pre-set values like the levels
--And the function "logify" which automatically logs the execution (and outcome)
--Of a function

local Log = class "Log"

local levels = {
  trace = colors.blue,
  debug = colors.lightBlue,
  success = colors.lime,
  info = colors.green,
  warn = colors.yellow,
  error = colors.orange,
  fatal = colors.red
}

function Log:initialize(obj)
  self._obj = obj
  self._sl = "info"
end

function Log:setObject(obj)
  self._obj = obj
end

function Log:setStandardLevel(lvl)
  self._sl = levels[lvl:lower()] and lvl:lower() or "info"
end

function Log:log(msg,lvl)
  lvl = lvl or self._sl
  lvl = lvl:lower() or self._sl
  self._obj:log(lvl:upper(),msg,levels[lvl])
end

function Log:logify(name, func)
  self:log(i18n("log.task.start",{task=name}))
  local ok,err = pcall(func)
  if(not ok) then
    self:log(i18n("log.task.error",{task=name, error=err}),"error")
    return false
  else
    self:log(i18n("log.task.success",{task=name}),"success")
    return true
  end
end

return Log
