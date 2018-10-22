#ifndef RefCountedObject_h_
#define RefCountedObject_h_ 1

/// A base class for objects that employ
/// reference counting based garbage collection.
///
/// Reference-counted objects inhibit construction
/// by copying and assignment.
class RefCountedObject
{
public:
/// Creates the RefCountedObject.
/// The initial reference count is one.
RefCountedObject() : refcount( 1 ) {}

/// Increments the object's reference count.
void duplicate() const { ++refcount; }

/// Decrements the object's reference count
/// and deletes the object if the count
/// reaches zero.
void release() const;

/// Returns the reference count.
int referenceCount() const { return refcount; }

protected:
/// Destroys the RefCountedObject.
virtual ~RefCountedObject() {}

private:
RefCountedObject( const RefCountedObject& );
RefCountedObject& operator = ( const RefCountedObject& );

mutable int refcount;
};


inline void RefCountedObject::release() const
{
if  ( --refcount == 0 ) delete this;
}

#endif
