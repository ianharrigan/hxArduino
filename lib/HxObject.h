#ifndef hxObject_h_
#define hxObject_h_ 1

#include "RefCountedObject.h"

class HxObject : public RefCountedObject {
    public:
        
    template<typename T>
    bool isA() {
        return (dynamic_cast<T*>(this) != nullptr);
    }
};

#endif