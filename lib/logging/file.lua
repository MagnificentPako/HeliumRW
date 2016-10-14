local File = class "FileLog"

function File:initialize(name)
  self._name = name
end

function File:log(tag,msg,col)
  local handle = fs.open(fs.combine("log",self._name..".log"),"a")
  handle.writeLine("["..tag.."] "..msg)
  handle.close()
end

return File
