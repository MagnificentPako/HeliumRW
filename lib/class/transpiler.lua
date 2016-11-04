local classPattern = "@class (.-) {(.+)}"
local importPattern = "import (.-) from (.-)\n"

local function transpileClass(str)
   return str:gsub("@class (.-) {(.+)}",function(header, body)
      local className, extends
      if(header:match("([^ \t]+) extends (.+)")) then
         className, extends = header:match("([^ \t]+) extends (.+)")
      else
         className = header:match("([^ \t]+)")
         extends = nil
      end
      local content = "local " .. className .. " = class('" .. className .. "'"..(extends and (","..extends..")") or ")").."\n"
      body:gsub("([a-zA-Z0-9_]+\(.-\))|\n-(.-)|\n-", function(functionName,_,functionBody)
         functionBody = functionBody:match("\n(.+)\n")
         content = content.."function "..className..":"..functionName.."\n"
         content = content..functionBody.."\n"
         content = content.."end\n\n"
      end)
      content = content.."return "..className
      return content
   end)
end

local function transpileImport(str)
   return str:gsub("import (.-) from (.-)\n", function(what,where)
      return "local " .. what .. " = require('"..where.."')['"..what.."']"
   end)
end

local function transpile(str)
   local out = str
   while(out:find(importPattern)) do
      local strt,ed = out:find(importPattern)
      local before = out:sub(1,strt-1)
      local after = out:sub(ed+1,#out)
      local between = out:sub(strt,ed)
      out = before..transpileImport(between)..after
   end
   while(out:find(classPattern)) do
      local strt,ed = out:find(classPattern)
      local before = out:sub(1,strt-1)
      local after = out:sub(ed+1,#out)
      local between = out:sub(strt,ed)
      out = before..transpileClass(between)..after
   end
   return out
end

return transpile
