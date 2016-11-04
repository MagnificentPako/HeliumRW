--This class will mirror everything into all the log-providers you give to it

local Mirror = class "MirrorLog"

function Mirror:initialize(...)
  self._logs = {...}
end

function Mirror:log(tag,msg,col)
  for k,v in pairs(self._logs) do
    v:log(tag,msg,col)
  end
end

return Mirror
