package;

class Main {
    //public var mac = [""];
    
    public function setup() {
        Arduino.pinMode(Arduino.LED_BUILTIN, Arduino.OUTPUT);
        Serial.begin(115200);
        
        Ethernet.maintain();
        
    }

    public function loop() {
        Arduino.digitalWrite(Arduino.LED_BUILTIN, Arduino.HIGH);

        var nativeArray:NativeArray<Int> = [0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED];
        for (na in nativeArray) {
        }
        
        /*
        var array = [1, 2, 3, 4, 5, 6];
        for (a in array) {
        }
        */
        
        Serial.println('high');

        Arduino.delay(1000);

        Arduino.digitalWrite(Arduino.LED_BUILTIN, Arduino.LOW);

        Serial.println('low');

        Arduino.delay(1000);
    }

    public function fn(arr:NativeArray<Int>) {
        
    }
    
    static function main() {
    }
}