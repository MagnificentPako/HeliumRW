--This class let's you easily log to the term

local Term = class "TermLog"

function Term:log(tag,msg,col)
  term.setTextColor(col)
  term.write("["..tag.."]")
  term.setTextColor(colors.white)
  print(" "..msg)
end

return Term
