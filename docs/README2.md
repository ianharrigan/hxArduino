# hxArduino



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
}
```


