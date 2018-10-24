# Basic blink tutorial

We will not recreate all tutorials form the arduino website.

But we will use the blink example to get you started: <https://www.arduino.cc/en/Tutorial/Blink>


## Setup

Besides having a Arduino and a way to connect it to your laptop, you don't need anything else.


## Code

This is as close as we can get to the orignal code:

```haxe
package;

class Main {

	// the setup function runs once when you press reset or power the board
    public function setup() {
		// initialize digital pin LED_BUILTIN as an output.
        Arduino.pinMode(Arduino.LED_BUILTIN, Arduino.OUTPUT);
    }

	// the loop function runs over and over again forever
    public function loop() {
        Arduino.digitalWrite(Arduino.LED_BUILTIN, Arduino.HIGH);		// turn the LED on (HIGH is the voltage level)
        Arduino.delay(1000);											// wait for a second
        Arduino.digitalWrite(Arduino.LED_BUILTIN, Arduino.LOW);			// turn the LED off by making the voltage LOW
        Arduino.delay(1000);											// wait for a second
    }

    static function main() {
    }
}
```

