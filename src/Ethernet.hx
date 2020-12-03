package;

@:include("Ethernet.h")
@:include("SPI.h")
@:native("Ethernet")
extern class Ethernet {
    public static function maintain():Int;
}