package;

class Main {
    public function setup() {
        Arduino.pinMode(Arduino.LED_BUILTIN, Arduino.OUTPUT);
        Serial.begin(115200);
    }

    public function loop() {
        Arduino.digitalWrite(Arduino.LED_BUILTIN, Arduino.HIGH);

        Serial.println('high');

        Arduino.delay(1000);

        Arduino.digitalWrite(Arduino.LED_BUILTIN, Arduino.LOW);

        Serial.println('low');

        Arduino.delay(1000);
    }

    static function main() {
    }
}