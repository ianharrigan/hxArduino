#include "haxe_Log.h"

void haxe_Log::trace(Dynamic d, haxe_PosInfos pos) {
    const char * buffer = d;
    Serial.println(buffer);

    if (buffer != NULL) {
        delete[] buffer;
    }
}

void haxe_Log::trace(String d, haxe_PosInfos pos) {
    Serial.println(d);
}
