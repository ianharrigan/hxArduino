package;
import test.Test1;
import test.Test2;

class Main {
    private var _test1:Test1 = new Test1();
    
    public function setup() {
        Arduino.pinMode(Arduino.LED_BUILTIN, Arduino.OUTPUT);
    }
    
    public function loop() {
        var test2:Test2 = new Test2();
        test2.setViaProxy(_test1, 1000);
        
        Arduino.digitalWrite(Arduino.LED_BUILTIN, Arduino.HIGH);
        
        Arduino.delay(_test1.get());
        
        Arduino.digitalWrite(Arduino.LED_BUILTIN, Arduino.LOW);
        
        Arduino.delay(_test1.get());
    }
    
    static function main() {
    }
}