local Base = require "lib.fs.types.base"
local Ram = class("RamFS", Base)

local function splitPath(path)
  local fields,length = {},0
  path:gsub("[^/]+", function(c)
    length = length + 1
    fields[length] = c
  end)
  return fields,length
end

local function splitFile(txt)
  local fields,length = {},0
  txt:gsub("[^\n]+", function(c)
    length = length + 1
    fields[length] = c
  end)
  return fields,length
end

local function dcopy(t)
  local tt = {}
  if(type(t) ~= "table") then return t end
  for k,v in pairs(t) do
    tt[dcopy(k)] = dcopy(v)
  end
  return tt
end

local function getNode(sys,path,create)
  local node = sys
  local cr = create and true or false
  local f,l = splitPath(path)
  if(path == "/") then
    return node
  else
    for i = 1, l do
      if(not (f[i] == ".")) then
        if((i == l) and (node[f[i]] == nil) and cr) then
          node[f[i]] = create
        end
        if(not node[f[i]]) then error("File doesn't exist",3) end
        if((not node[f[i]].dir) and not(i == l)) then error("Not a folder",2) end
        if(i == l) then
          node = node[f[i]]
        else
          node = node[f[i]].content
        end
      end
    end
    return node
  end
end

local function deleteNode(sys,path)
  local node = sys
  local cr = create and true or false
  local f,l = splitPath(path)
  if(path == "/") then
    for k,v in pairs(node) do node[k] = nil end
  else
    for i = 1, l do
      if(not (f[i] == ".")) then
        if(not node[f[i]]) then error("File doesn't exist",3) end
        if((not node[f[i]].dir) and not(i == l)) then error("Not a folder",2) end
        if(i == l) then
          node[f[i]] = nil
        else
          node = node[f[i]].content
        end
      end
    end
  end
end

function Ram:initialize(parent)
  Base.initialize(self)
  self._parent = parent or fs
  self._sys = {}
end

function Ram:loadTable(tbl)
  self._sys = tbl
end

-- Load a dumped RamFS
function Ram:loadFile(file)
  local handle = self._parent:open(file,"r")
  local tbl = handle.readAll()
  tbl = textutils.unserialize(tbl)
  self._sys = tbl
end

-- Dump the RamFS into a file
function Ram:saveFile(file)
  local handle = self._parent:open(file,"w")
  handle.write(textutils.serialize(self._sys))
  handle.close()
end

function Ram:dump()
  return textutils.serialize(self._sys)
end

-- Import from the original FS into the RamFS
function Ram:import(path,to,deep)
  local to = to or "/"
  local deep = deep or false

  if(not self:isDir(to)) then self:makeDir(to) end
  if(not self._parent:exists(path)) then error "File/Folder doesn't exist" end

  local node = getNode(self._sys,to)

  local function imp(base,from,too)
    if(from == "") then
      if(to ~= "/") then node.dir = true end
      for k,v in pairs(self._parent:list(base)) do
        imp(base,v,too)
      end
    else
      local comb = fs.combine(base,from)
      local f,l = splitPath(from)
      if(self._parent:isDir(comb)) then
        self:makeDir(fs.combine(too,from))
        if(deep) then
          for k,v in pairs(self._parent:list(fs.combine(base,from))) do
            imp(base,fs.combine(from,v),too)
          end
        end
      else
        local handle = self._parent:open(fs.combine(base, from),"r")
        local content = handle.readAll()
        local s,e = content:find("^%-%-meta=.+%%\n")
        local meta = ""
        if(s) then
          meta = content:sub(1,e)
          meta = content:match("^%-%-meta=(.+)%%%%\n")
          content = content:match("^%-%-meta=.+%%\n(.+)")
        end

        handle.close(); handle = self:open(fs.combine(too,from),"w")
        handle.write(content)
        handle.close()

        if(s) then
          local node = getNode(self._sys, fs.combine(too,from))
          node.meta = textutils.unserialize(meta)
        end

      end
    end
  end

  imp(path,"",to)
end

-- Excludes a specific file from the RamFS
function Ram:exclude(path)
  --#TODO:10 Add functionality to @ram_exclude +RamFS
end

-- Exports the RamFS into the original FS
function Ram:export(path,to,deep)
  local base = path
  local from = ""
  local deep = deep or false
  local what = what or "/"

  local function exp(base,from,to)
    if(self:exists(base) and (not self:isDir(base))) then
      local handle = self:open(fs.combine(base,from),"r")
      local content = handle.readAll()
      handle.close(); handle = self._parent:open(fs.combine(to,from),"w")
      handle.write(content)
      handle.close()
      return
    end
    if(from == "") then
      if(to ~= "/") then
        self._parent:makeDir(to)
        for k,v in pairs(self:list(base)) do
          exp(base,v,to)
        end
      end
    else
      local f,l = splitPath(from)
      local comb = fs.combine(base,from)
      if(self:isDir(comb)) then
        self._parent:makeDir(fs.combine(to,from))
        if(deep) then
          for k,v in pairs(self:list(fs.combine(base,from))) do
            exp(base, fs.combine(from,v),to)
          end
        end
      else
        local handle = self:open(fs.combine(base,from),"r")
        local content = handle.readAll()
        local metadata = getNode(self._sys, fs.combine(base,from)).meta
        metadata = textutils.serialize(metadata):gsub("\n","")
        content = "--meta="..metadata.."%%\n"..content
        handle.close(); handle = self._parent:open(fs.combine(to,from),"w")
        handle.write(content)
        handle.close()
      end
    end
  end

  exp(base,from,to)

end

-- FS FUNCTIONS START

function Ram:list(path)
  local node
  local f,l = splitPath(path)
  if(l>=1) then
    node = getNode(self._sys,path).content
  else
    node = self._sys
  end
  local list = {}
  for k,v in pairs(node) do
    table.insert(list,k)
  end
  return list
end

function Ram:open(path, mode)
  local handle = {}
  local node

  if(mode == "r") then
    node = getNode(self._sys,path)
  elseif((mode == "w") or (mode == "a")) then
    node = getNode(self._sys,path,{content = {}, meta={}})
  end

  if(node.dir) then error "Can't open a folder" end

  function handle.close()
    handle = nil
  end

  if(mode == "r") then
    handle._lines = node.content
    handle._lines = self:applyMiddleware("read",handle._lines)
    handle._pointer = 1

    function handle.readLine()
      if(handle._pointer > #handle._lines) then return nil end
      local line = handle._lines[handle._pointer]
      handle._pointer = handle._pointer + 1
      return line
    end

    function handle.readAll()
      handle._pointer = #handle._lines+1
      local tbl = dcopy(handle._lines)
      local str = ""
      for k,v in pairs(tbl) do
        if(true) then
          str = str..v.."\n"
        end
      end
      return str
    end

  elseif(mode == "w") then
    handle._lines = {}

    function handle.write(text)
      lin = {}
      text:gsub("([^\n]*)[\n]?", function(c) table.insert(lin,c) end)
      --if(text:sub(#text,#text) == "\n") then table.insert(lin,"") end
      for k,v in pairs(lin) do
        if(k>1) then
          table.insert(handle._lines,v)
        else
          if(#handle._lines > 0) then
              handle._lines[#handle._lines] = handle._lines[#handle._lines]..v
          else
            table.insert(handle._lines,v)
          end
        end
      end
    end

    function handle.writeLine(text)
      return handle.write(text .. "\n")
    end

    function handle.flush()
      local cont = dcopy(handle._lines)
      cont = self:applyMiddleware("save", cont)
      node.content = dcopy(cont)
    end

    function handle.close()
      handle.flush()
      handle = nil
    end

  elseif(mode == "a") then
    error "mode not supported (yet)"
  else
    error "Unknown mode"
  end

  return handle
end

function Ram:makeDir(path)
  local f,l = splitPath(path)
  local node = self._sys
  local p = ""
  if(l > 1) then
    for i = 1, l-1 do
      p = p..f[i].."/"
    end
  end
  if(self:exists(p)) then
    getNode(self._sys,path, {dir = true, content={}})
  end
end

function Ram:exists(path)
  if((path == "") or path == "/") then return true end
  local f,l = splitPath(path)
  local node = self._sys
  for k,v in pairs(f) do
    if(node[v]) then
      node = node[v].content
      if(k == l) then
        return true
      end
    else
      return false
    end
  end
end

function Ram:isDir(path)
  if(not self:exists(path)) then return false end
  return getNode(self._sys,path).dir and true or false
end

function Ram:isReadOnly()
  return false
end

function Ram:getName(path)
  local f,l = splitPath(path)
  return f[l]
end

function Ram:getDir(path)
  local f,l = splitPath(path)
  local p = ""
  for i = 1,l-1 do
    p = fs.combine(p,f[i])
  end
  return p
end

function Ram:move(from,to)
  if(self:isDir(self:getDir(from)) and self:isDir(self:getDir(to))) then
    if(self:exists(from)) then
      local handle = self:open(from,"r")
      local content = handle.readAll()
      handle.close()
      handle = self:open(to,"w")
      handle.write(content)
      handle.close()
      self:delete(from)
    end
  end
end

function Ram:copy(from,to)
  if(self:isDir(self:getDir(from)) and self:isDir(self:getDir(to))) then
    if(self:exists(from)) then
      local handle = self:open(from,"r")
      local content = handle.readAll()
      handle.close()
      handle = self:open(to,"w")
      handle.write(content)
      handle.close()
    end
  end
end

function Ram:delete(path)
  if(self:exists(path)) then
    deleteNode(self._sys, path)
  end
end

function Ram:getMetadata(path,key)
  local node = getNode(self._sys,path)
  return key and dcopy(node.meta[key]) or dcopy(node.meta)
end

function Ram:setMetadata(path,key,value)
    local node = getNode(self._sys,path)
    node.meta[key] = dcopy(value)
end

-- FS FUNCTIONS END

function Ram:makeLegacy()
  local legacy = Base.makeLegacy(self)
  legacy.getMetadata = function(...) return self:getMetadata(...) end
  legacy.setMetadata = function(...) return self:setMetadata(...) end
  return legacy
end

return Ram
