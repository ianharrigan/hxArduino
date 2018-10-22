package test;

@:stackOnly
class Test1 {
    private var _delay:Int = 100;
    
    public function new() {
    }
    
    public function get():Int {
        return _delay;
    }
    
    public function set(value:Int) {
        _delay = value;
    }
}