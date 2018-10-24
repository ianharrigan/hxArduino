# hxArduino on Windows

Make sure you followed the [Getting Started](start/getting_started.md) instructions first.


# Notes
* Must have an `ARDUINO_HOME` environment variable set (eg: `C:\\PROGRA~2\\Arduino`)
* Fair amount of syntax not yet implemented in generator (eg: loops)
* Undoubtedly assumptions made that are specific to my system (paths, com ports, etc - needs ironing out)
* Only tested on windows, and a single windows box (mine!)
* Currently skips alot of haxe "internal" classes (no point in trying to generated them till generator is at least all wired up)
* main.cpp (not generated) makes assumption that there is a `Main.h` and a `Main` c++ class in entry point, eg:
