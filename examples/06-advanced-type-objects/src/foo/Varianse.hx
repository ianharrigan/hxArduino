package foo;

class Base {
    public function new() {}

    public function getName(): String
        return "BaseClass";
}
class ChildNo1 extends Base {
    public function new() {
        super();
    }

    public override function getName():String 
        return "ChildNo1Class";
}
class ChildNo2 extends Base {
    public function new() {
        super();
    }

    public override function getName():String 
        return "ChildNo2Class";
}