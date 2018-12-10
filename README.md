
# hxArduino

* Includes basic Arduino externs (`Arduino`, `LiquidCrystal`, `MemoryFree`, see: `/lib`)
* Custom C++ generator
* Compiler utility class to compile & link generated c++
* Installer utility class to push to Arduino device
* Monintor utility class to start reading from serial com port via hxSerial for program traces

# Usage

* Download hxArduino to folder
* `haxelib dev hxArduino path/to/folder`
* `haxe -lib hxArduino -cp src -no-output -main Main`
* `haxelib run hxArduino -test

# Notes
* Must have an `ARDUINO_HOME` environment variable set (eg: `C:\\PROGRA~2\\Arduino`)
* Currently skips alot of haxe "internal" classes (no point in trying to generated them till generator is at least all wired up)
* main.cpp (not generated) makes assumption that there is a `Main.h` and a `Main` c++ class in entry point, eg:

See examples for various examples
