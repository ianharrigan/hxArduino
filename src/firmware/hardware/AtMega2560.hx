package firmware.hardware;

import firmware.hardware.memory.*;

class AtMega2560 implements MCU {
    public function new() { }

    public var UploadingSpeed(get, never): Int;

    public var Protocol(get, never): String;
    public var Name(get, never): String;

    public function get_Name(): String
        return "atmega2560";
    
    public function get_Protocol(): String
        return "arduino";

    public function get_UploadingSpeed(): Int 
        return 115200;
}