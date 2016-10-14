--[[

MIT License Terms
=================

Copyright (c) 2012 Enrique García Cota.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

--]]

local unpack = unpack or table.unpack -- lua 5.2 compat

-- matches a string of type %{age}
local function interpolateValue(string, variables)
  return string:gsub("(.?)%%{%s*(.-)%s*}",
    function (previous, key)
      if previous == "%" then
        return
      else
        return previous .. tostring(variables [key])
      end
    end)
end

-- matches a string of type %<age>.d
local function interpolateField(string, variables)
  return string:gsub("(.?)%%<%s*(.-)%s*>%.([cdEefgGiouXxsq])",
    function (previous, key, format)
      if previous == "%" then
        return
      else
        return previous .. string.format("%" .. format, variables[key] or "nil")
      end
    end)
end

local function interpolate(pattern, variables)
  variables = variables or {}
  local result = pattern
  result = interpolateValue(result, variables)
  result = interpolateField(result, variables)
  result = string.format(result, unpack(variables))
  return result
end

return interpolate
