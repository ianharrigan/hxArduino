package test;

class Test2 {
    public function new() {
    }
    
    public function setViaProxy(test1:Test1, value:Int) {
        test1.set(value);
    }
}