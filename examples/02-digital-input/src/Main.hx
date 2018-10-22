package;

class Main {
    public function setup() {
        Arduino.pinMode(Arduino.LED_BUILTIN, Arduino.OUTPUT);
        Arduino.pinMode(2, Arduino.INPUT);
        Arduino.pinMode(3, Arduino.INPUT);
    }
    
    public function loop() {
        var pin2 = Arduino.digitalRead(2);

        if (pin2 == Arduino.HIGH) {
            Arduino.digitalWrite(Arduino.LED_BUILTIN, Arduino.HIGH);
        }
        // TODO: no if / else (yet!)
        if (pin2 == Arduino.LOW) {
            Arduino.digitalWrite(Arduino.LED_BUILTIN, Arduino.LOW);
        }
        
        Arduino.delay(1000);
        
        var pin3 = Arduino.digitalRead(3);
        Arduino.digitalWrite(Arduino.LED_BUILTIN, pin3);
        
        Arduino.delay(1000);
    }
    
    static function main() {
    }
}