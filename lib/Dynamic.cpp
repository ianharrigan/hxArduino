
#include "Dynamic.h"
#include <string.h>

Dynamic::~Dynamic() {
    if (_string != NULL)  {
        delete[] _string;
    }
}

Dynamic::Dynamic() {
}

Dynamic::Dynamic(const int n) {
    _int = n;
    _type = DynamicType::DT_Int;
}

Dynamic::Dynamic(const char * s) {
    _string_size = strlen(s) + 1;  
    _string = new char[_string_size];  
    if (_string != NULL) {
        strcpy(_string, s);
    }
    _type = DynamicType::DT_String;
}

Dynamic::Dynamic(String s) {
    _string_size = s.length() + 1;  
    _string = new char[_string_size];  
    if (_string != NULL) {
        strcpy(_string, s.c_str());
    }
    _type = DynamicType::DT_String;
}

Dynamic::operator const char *() const {
    char* buffer = NULL;
    switch (_type) {
        case DynamicType::DT_Int:
            buffer = new char[32];
            sprintf(buffer, "%d", _int);
            break;
        case DynamicType::DT_String:
            buffer = new char[_string_size + 1];
            strcpy(buffer, _string);
            break;
    }
    return buffer;
}
