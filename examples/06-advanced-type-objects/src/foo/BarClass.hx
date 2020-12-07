package foo;

class BarClass extends BarClassBase {
    public function new() { }


    public var x1(default, null):Int;
    public var x2(get, never):String;
}

class BarClassBase {
    public function get_x2(): String
        return "test_getter";
}