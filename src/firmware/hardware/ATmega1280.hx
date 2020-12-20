package firmware.hardware;

import firmware.hardware.memory.*;

class AtMega1280 implements MCU {
    public function new() { }

    public var FlashMemory(get, never): Null<IMemory>;
    public var EEPROMemory(get, never): Null<IMemory>;

    public var UploadingSpeed(get, never): Int;

    public var Protocol(get, never): String;
    public var Name(get, never): String;

    public function get_Name(): String
        return "atmega1280";
    
    public function get_Protocol(): String
        return "arduino";

    public function get_UploadingSpeed(): Int 
        return 57600;
    
    public function get_FlashMemory(): Null<IMemory>
        return new FlashMemory(126976, 128);

    public function get_EEPROMemory(): Null<IMemory>
        return new EEPROMemory(8192);
}