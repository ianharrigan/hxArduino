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
            case "atmega2560":
                return new AtMega2560();
            case "megaatmega2560":
                return new MegaAtMega2560();
            case "nanoatmega328p":
                return new NanoAtMega328p();
            case _:
               return null;
        }
    }
}