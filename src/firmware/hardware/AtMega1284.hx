package firmware.hardware;

import firmware.hardware.memory.*;

class AtMega328P implements MCU {
    public function new() { }

    public var DeviceID(get, never): Null<Int>;
    public var DeviceSignature(get, never): Null<String>;

    public var FlashMemory(get, never): Null<IMemory>;
    public var EEPROMemory(get, never): Null<IMemory>;

    public function get_DeviceID(): Null<Int>
        return 0x86;

    public function get_DeviceSignature(): Null<String>
        return "1E-95-0F";
    
    public function get_FlashMemory(): Null<IMemory>
        return new FlashMemory(32 * 1024, 128);

    public function get_EEPROMemory(): Null<IMemory>
        return new EEPROMemory(1024);
}