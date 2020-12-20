package firmware.hardware;

import haxe.Exception;
import firmware.hardware.Atmega1280;
import firmware.hardware.memory.*;

interface MCU {
    public var FlashMemory(get, never): Null<IMemory>;
    public var EEPROMemory(get, never): Null<IMemory>;

    public var UploadingSpeed(get, never): Int;
}


class MCUProvider {
    public static function byCode(code: String): Null<MCU> {
        switch code.toLowerCase() {
            case "atmega328p":
                return new AtMega328P();
            case "atmega168":
                return new AtMega168();
            case "atmega2560":
                return new AtMega2560();
            case "atmega32u4":
                return new AtMega32u4();
            case "atmega1280":
                return new ATmega1280();
            case _:
               return null;
        }
    }
}