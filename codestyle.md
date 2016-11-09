# Code Style

## LClass
Every file ending with .lclass will be transpiled by dofile before running it.The transpiler itself converts some syntactical sugar for you so you don't haveto interact with all the "ugly"lower-level stuff which handles the classes.

### Creating a class
Creating a class is easy. Just create a new file which ends with ".lclass" and Helium will transpile it whenever the file is run. The basic LClass syntax looks like this:
```
@class ClassName {
  initialize() |
    --Code goes here
  |
}
```
Some things you might notice:
- defining the class itself looks a bit like Java
- You don't need to write anything like `function ClassName:initialize() end` to generate functions. That's done behind-the-scenes for you. Just write the "head" of the function and append two |'s. Your code will go between these.

### Importing other classes (or libraries)
Importing is pretty straight-forward:
```
-- You either go the old-school way...
local BaseClass = require "path.to.BaseClass"

-- Or you use the new, transpiled, syntax(es)...
import BaseClass from path.to
import {BaseClass, OtherClass} from path.to
```
Note: when using the new syntax you don't explicitly define the file to import in the path: in Lua it would look like this `local BaseClass = require("path.to")["BaseClass"]`. The path has to contain an init.lua file which returns a table of this format:
```
return {
  ["BaseClass"] = require "path.to.BaseClass"
}
```
I prefer to use the [ImportProxy]() though because it eliminates some critical problems with such a straight-forward table.

### Extending a class
```
import BaseClass from path.to.BaseClass
@class ExtendingClass extends BaseClass {
  initialize() |
    BaseClass.initialize(self) --call parent initialize method on self
  |
}
```

Note that it IS possible to write normal above and below an LClass, but you shouldn't "interfer" with the class. Everything after the class wouldn't be executed, for example because of how the transpiler works right now. Just stick to "1 class per file" and you should be good to go.
