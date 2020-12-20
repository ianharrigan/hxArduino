package firmware.hardware;

import firmware.hardware.memory.*;

class MegaAtMega2560 implements MCU {
    public function new() { }

    public var FlashMemory(get, never): Null<IMemory>;
    public var EEPROMemory(get, never): Null<IMemory>;

    public var UploadingSpeed(get, never): Int;

    public function get_UploadingSpeed(): Int 
        return 115200;
    
    public function get_FlashMemory(): Null<IMemory>
        return new FlashMemory(253952, 128);

    public function get_EEPROMemory(): Null<IMemory>
        return new EEPROMemory(8192);
}