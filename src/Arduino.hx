package;

@:include("Arduino.h")
extern class Arduino {
    public static inline var LED_BUILTIN:Int = untyped 'LED_BUILTIN';
//    public static inline var LED_BUILTIN:Int;

    public static inline var INPUT:Int = untyped 'INPUT';
    public static inline var OUTPUT:Int = untyped 'OUTPUT';
    
    public static inline var HIGH:Int = untyped 'HIGH';
    public static inline var LOW:Int = untyped 'LOW';
    
    public static function pinMode(pin:Int, mode:Int):Void;
    public static function digitalWrite(pin:Int, value:Int):Void;
    public static function digitalRead(pin:Int):Int;
    public static function analogRead(pin:Int):Int;
    public static function delay(amount:Int):Void;
}
