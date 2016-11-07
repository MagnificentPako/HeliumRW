> **Helium /ˈhiːliəm/**

> Helium is a colorless, odorless, tasteless, non-toxic, inert, monatomic gas.
> The first in the noble gas group in the periodic table.

<!-- TOC depthFrom:1 depthTo:6 withLinks:1 updateOnSave:1 orderedList:0 -->

- [What is Helium?](#what-is-helium)
- [Features](#features)
- [How to contribute](#how-to-contribute)

<!-- /TOC -->

# What is Helium?
Helium is a new CC OS designed to be as awesome as possible. Even though it only
features "basic" stuff right now, I got much more planned.

# Features
- Full TLCO: It runs "outside the box" and (probably) gains a speed increase by
  running without the shell
- It uses [Middleclass.lua](https://github.com/kikito/middleclass) to provide
  object oriented code + a custom transpiler for a "simpler" syntax
- Sandboxing
- Custom filesystems: The shell is running inside a sandbox which runs inside
  an emulated (RAM-only) filesystem with no way out
- It has a shell with the basic commands you would expect
- Files (atleast inside the RamFS) can have metadata which even persists between
  import/export from/to another filesystem
- every sandbox adds a folder called "persistent" to the filesystem which allows
  the program(s) ran inside the sandbox to securely store data on the drive
  (everything outside of persistent will be lost after a restart though)
- A simple OO utility which allows you to easily create commandline programs
- A ton of libraries ready for you to (ab-)use

# How to contribute
I am using [imdone.io](https://imdone.io/) to keep track of all the stuff going
on in Helium. Just check out the open issues and see if there's something you
would like to do. Then create a pull request fixing the issue (and probably also
modifying the imdone comment) and I will add it ASAP!
