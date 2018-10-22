package;

@:include("MemoryFree.h")
extern class MemoryFree {
    public static function freeMemory():Int;
    public static function freeMemoryPercent():Int;
}