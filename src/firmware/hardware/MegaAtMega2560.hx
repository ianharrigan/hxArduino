package firmware.hardware;

class MegaAtMega2560 extends AtMega2560 {
    public override function get_Protocol(): String
        return "wiring";
}