package;

class Main {
    public function setup() {
        Arduino.pinMode(Arduino.LED_BUILTIN, Arduino.OUTPUT);
    }
    
    public function loop() {
        var arr = [Arduino.HIGH, Arduino.LOW, Arduino.HIGH, Arduino.LOW, Arduino.HIGH, Arduino.LOW, Arduino.HIGH];
        for (a in arr) {
            Arduino.digitalWrite(Arduino.LED_BUILTIN, a);
        }
    }
    
    static function main() {
    }
}