package;

@:include("Arduino.h")
@:native("Serial")
extern class Serial {

    // https://www.arduino.cc/reference/en/language/functions/communication/serial/

    public static function begin(baud:Int):Void;
    public static function println(value:String):Void;
    public static function available():Int;
    public static function read():Int;
    @:overload(function(val:Int, len:Int):Int {})
    public static function write(val:Int):Int;
    // public static function print(value:Dynamic, ?format:String):Void;

/**
If (Serial)
available()
availableForWrite()
begin()
end()
find()
findUntil()
flush()
parseFloat()
parseInt()
peek()
print()
println()
read()
readBytes()
readBytesUntil()
readString()
readStringUntil()
setTimeout()
write()
serialEvent()
*/
}
