package firmware.hardware;

class MegaAtMega2560 extends AtMega2560 {
    public function new() 
        super();
    public override function get_Protocol(): String
        return "wiring";
}