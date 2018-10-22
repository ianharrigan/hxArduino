package;

class Main {
    public function setup() {
        Arduino.pinMode(Arduino.LED_BUILTIN, Arduino.OUTPUT);
    }
    
    public function loop() {
        Arduino.digitalWrite(Arduino.LED_BUILTIN, Arduino.HIGH);
        
        Arduino.delay(1000);
        
        Arduino.digitalWrite(Arduino.LED_BUILTIN, Arduino.LOW);
        
        Arduino.delay(1000);
    }
    
	static function main() {
	}
}