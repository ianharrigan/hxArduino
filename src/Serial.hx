package;

@:include("Arduino.h")
@:native("Serial")
extern class Serial {
    public static function println(value:String):Void;
}