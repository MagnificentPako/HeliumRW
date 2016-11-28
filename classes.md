# Classes
Note: I expect that your script already imported the classes if they are not present in the "normal environment". The names I'm using here are just examples. You could use any name you want.
## Config
### WTF is this?
A simple class which allows you to store key/value configs in files.
### Usage
#### Creating an instance
```lua
-- The current design sucks. I have no idea why I'm using a callback to handle it if a new config was created
local new
local conf = Config:new("path/to/config", function() new = true end)
```
#### Setting/Getting some values
```lua
-- Setting
conf:set("path.to.value", "Content")
conf:set("see.that.notation", "pretty, right?")

-- Getting
print(conf:get"see.that.notation", "Yep!")
```
#### Saving
```lua
conf:save()
```

## Container
### WTF is this?
This is just a wrapper for a RamFS. It basically allows you to store an entire filesystem in one file, without having to care about setting up a RamFS. (which isn't much, actually)
### Usage
#### Creating a Container
```lua
local container = Container:new()
```
#### Importing files (and folders) into the container
```lua
container:import "path/to/folder/file"
```
#### Saving/Loading a Container
```lua
-- Loading
container:load "path/to/container"

-- Saving
container:save "path/to/container"
```
## CoroutineManager
  WIP

## ImportProxy
### WTF is this?
A simple class which you can use to semi-magically make a folder work with the transpiled "import".
### Usage
Note: This is expected to only run inside a init.lua file. Although you might find some other use case though.
```lua
local proxy = ImportProxy:new()

-- Add files to the proxy
proxy:add("ClassName","path/to/class")

-- Return the finished table
return proxy:convert()
```

## Sandbox
WIP

## Resource
WIP

## Logging
WIP

### BaseLog
WIP

### FileLog
WIP
### TermLog
WIP
### MirrorLog
WIP

## FS
WIP
### Middleware
WIP
#### BaseMiddleware
WIP
#### Base64Middleware
WIP
### Types
WIP
#### BaseFS
WIP
#### RamFS
WIP
#### WrapperFS
WIP

## CLApp
WIP
