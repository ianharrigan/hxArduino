# main.cpp

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

Get your empty template here:

```haxe
package;

class Main {

	// the setup routine runs once when you press reset:
    public function setup() {
    }

	// the loop routine runs over and over again forever:
    public function loop() {
    }

    static function main() {
    }
}
```
