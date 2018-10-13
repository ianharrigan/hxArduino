#ifndef Dynamic_h_
#define Dynamic_h_ 1

//#include <string.h>

#include <Arduino.h>

class Dynamic {
    public:
        enum DynamicType {
            DT_Int = 1,
            DT_String = 2
        };

        ~Dynamic();
        Dynamic();
        Dynamic(const int n);
        Dynamic(const char * s);
        Dynamic(String s);

        operator const char *() const;
        
        DynamicType _type;
        int _int;
        char * _string = NULL;
        size_t _string_size;
};

#endif
