package firmware.hardware;

class NanoAtMega328p extends AtMega328P {
    public override function get_Name(): String
        return "atmega328p";
    public override function get_UploadingSpeed(): Int 
        return 57600;
}

