package;

@:include("Arduino.h")
extern class Arduino {
    // https://www.arduino.cc/reference/en/#functions

    public static inline var LED_BUILTIN:Int = untyped 'LED_BUILTIN';

    public static inline var A0:Int = untyped 'A0';
    public static inline var A1:Int = untyped 'A1';
    public static inline var A2:Int = untyped 'A2';
    public static inline var A3:Int = untyped 'A3';
    public static inline var A4:Int = untyped 'A4';
    public static inline var A5:Int = untyped 'A5';
    public static inline var A6:Int = untyped 'A6';
    public static inline var A7:Int = untyped 'A7';

    public static inline var INPUT:Int = untyped 'INPUT';
    public static inline var OUTPUT:Int = untyped 'OUTPUT';

    public static inline var HIGH:Int = untyped 'HIGH';
    public static inline var LOW:Int = untyped 'LOW';

    // Digital I/O
    public static function pinMode(pin:Int, mode:Int):Void;
    public static function digitalWrite(pin:Int, value:Int):Void;
    public static function digitalRead(pin:Int):Int;

    // Analog I/O
    public static function analogRead(pin:Int):Int;
    // analogReference()
    // analogWrite()

    // Time
    public static function delay(amount:Int):Void;
    // delayMicroseconds()
    // micros()
    // millis()


    public static function map(value:Int, fromLow:Int, fromHigh:Int, toLow:Int, toHigh:Int):Int;
}
