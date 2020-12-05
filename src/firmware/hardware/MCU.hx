package firmware.hardware;

import firmware.hardware.memory.*;

interface MCU {
    public var DeviceID(get, never): Null<Int>;
    public var DeviceSignature(get, never): Null<String>;

    public var FlashMemory(get, never): Null<IMemory>;
    public var EEPROMemory(get, never): Null<IMemory>;
}