# hxArduino

* Includes basic Arduino externs (`Arduino`, `LiquidCrystal`, `MemoryFree`, custom haxe "bits" like haxe_Log::trace - see: `/lib`)
* Custom C++ generator 
* [Messy] "compiler" .hx class to compile build / link generated c++
* Ability to push to Arduino device (hardcoded to COM3 - needs to change!)
* Ability to start reading from serial com port via hxSerial for program traces (hardcoded to COM3 - needs to change!)

# Usage
* Download hxArduino to folder
* `haxelib dev hxArduino path/to/folder`
* `haxe -lib hxArduino -cp src -neko dummy.n -main Main`
	* (Need to use neko dummy output for now - not entirely sure why)
* `haxelib run hxArduino test C:\Temp\temp2\bin\generated`
	* Makes COM port assumption (needs to change!)   

# Notes
* Must have an `ARDUINO_HOME` environment variable set (eg: `C:\\PROGRA~2\\Arduino`)
* Fair amount of syntax not yet implemented in generator (eg: loops)
* Undoubtedly assumptions made that are specific to my system (paths, com ports, etc - needs ironing out)
* Only tested on windows, and a single windows box (mine!)
* Currently skips alot of haxe "internal" classes (no point in trying to generated them till generator is at least all wired up)
* main.cpp (not generated) makes assumption that there is a `Main.h` and a `Main` c++ class in entry point, eg:

```cpp
#include <Arduino.h>
#include "Main.h" 

...

int main(void)
{
	...
    Serial.begin(115200);

    Main main;
	main.setup();
    
	for (;;) {
		main.loop();
		...
	}
        
	return 0;
}
```

# Example

```haxe
package;

import test.TestClass1;
import test.TestClass2;

class Main {
    // class level class decl
    private var _t1:TestClass1 = new TestClass1();
    
    function setup() {
        Arduino.pinMode(Arduino.LED_BUILTIN, Arduino.OUTPUT);
    }
    
    function loop() {
        // function level class decl
        var t2 = new TestClass2();
        // set value in t1 via t2 (ensure pass as ref)
        t2.setViaRef(_t1, 500);
        
        Arduino.digitalWrite(Arduino.LED_BUILTIN, Arduino.HIGH);
        
        trace("Delaying for " + _t1.get() + "ms");
        Arduino.delay(_t1.get());
        
        Arduino.digitalWrite(Arduino.LED_BUILTIN, Arduino.LOW);
        
        trace("Delaying for " + _t1.getInline() + "ms");
        Arduino.delay(_t1.getInline());
        
        var mem = MemoryFree.freeMemory();
        trace("Memory free: " + mem + "bytes");        
    }
    
	static function main() {
	}
}
```

```haxe
package test;

class TestClass1 {
    private var _delay:Int = 2000;
    
    public function new() {
    }
    
    public function set(value:Int) {
        _delay = value;
    }
    
    public function get():Int {
        return _delay;
    }
    
    public inline function getInline():Int {
        return _delay;
    }
}
```

```haxe
package test;

class TestClass2 {
    public function new() {
    }
    
    public function setViaRef(t1:TestClass1, value:Int) {
        t1.set(value);
    }
}```
