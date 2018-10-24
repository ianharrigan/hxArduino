# Baud

The data rate in bits per second (baud) for serial data transmission.

For communicating with the computer, use one of these rates: 300, 600, 1200, 2400, 4800, 9600, 14400, 19200, 28800, 38400, 57600, or 115200.

## fixed baud rate

currently this project has a fixed baud rate: `115200`

## Code

Simple example:

```haxe
package;

class Main {
    public function setup() {
        Serial.begin(115200); 		// opens serial port, sets data rate to 115200 bps
    }

    public function loop() {
        Serial.println('FOO');
        Arduino.delay(1000);
        Serial.println('BAR');
        Arduino.delay(1000);
    }

    static function main() {
    }
}
```