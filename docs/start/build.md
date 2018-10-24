# build

So how to build and test your project?

Lets use the simple blink example:
```
+ blink
	+ src
		- Main.hx
	- build.hxml
```

## Main.hx

First you need a Haxe file you want to convert and upload to Arduino:

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

## build.hxml

create also a build file

```bash
-cp src
-lib hxArduino
--no-output
-main Main
```

## run

```bash
cd path/to/folder
haxe build.hxml
```

this will create an extra folder `build`

## test on Arduino

(make sure you followed instructions from [usage](usage.md))

OSX (asuming you use port `/dev/cu.usbmodem14101`)

```bash
haxelib run hxArduino test -port /dev/cu.usbmodem14101
```

WINDOWS (asuming you use port `COM3`)

```bash
haxelib run hxArduino test -port COM3
```
