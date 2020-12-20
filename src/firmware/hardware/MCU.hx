package firmware.hardware;

import firmware.hardware.*;
import firmware.hardware.memory.*;

interface MCU {
    public var FlashMemory(get, never): Null<IMemory>;
    public var EEPROMemory(get, never): Null<IMemory>;

    public var UploadingSpeed(get, never): Int;

    public var Protocol(get, never): String;
    public var Name(get, never): String;
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
                return new AtMega1280();
            case "megaatmega2560":
                return new MegaAtMega2560();
            case _:
               return null;
        }
    }
}