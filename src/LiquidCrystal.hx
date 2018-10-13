package;

@:include("LiquidCrystal.h")
extern class LiquidCrystal {
    public function new(rs:Int, enable:Int, d0:Int, d1:Int, d2:Int, d3:Int) {
    }
    
    public function begin(cols:Int, rows:Int):Void;
    public function setCursor(col:Int, row:Int):Void;
    public function print(s:String):Void;
    public function clear():Void;
}
