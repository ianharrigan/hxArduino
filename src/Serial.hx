package;

@:include("Arduino.h")
@:native("Serial")
extern class Serial {
    public static function begin(baud:Int):Void;
    public static function println(value:String):Void;
}
