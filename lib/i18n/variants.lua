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

local variants = {}

local function reverse(arr, length)
  local result = {}
  for i=1, length do result[i] = arr[length-i+1] end
  return result, length
end

local function concat(arr1, len1, arr2, len2)
  for i = 1, len2 do
    arr1[len1 + i] = arr2[i]
  end
  return arr1, len1 + len2
end

function variants.ancestry(locale)
  local result, length, accum = {},0,nil
  locale:gsub("[^%-]+", function(c)
    length = length + 1
    accum = accum and (accum .. '-' .. c) or c
    result[length] = accum
  end)
  return reverse(result, length)
end

function variants.isParent(parent, child)
  return not not child:match("^".. parent .. "%-")
end

function variants.root(locale)
  return locale:match("[^%-]+")
end

function variants.fallbacks(locale, fallbackLocale)
  if locale == fallbackLocale or
     variants.isParent(fallbackLocale, locale) then
     return variants.ancestry(locale)
  end
  if variants.isParent(locale, fallbackLocale) then
    return variants.ancestry(fallbackLocale)
  end

  local ancestry1, length1 = variants.ancestry(locale)
  local ancestry2, length2 = variants.ancestry(fallbackLocale)

  return concat(ancestry1, length1, ancestry2, length2)
end

return variants
