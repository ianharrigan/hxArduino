#ifndef Helpers_h_
#define Helpers_h_ 1

template<class T, size_t N>
constexpr size_t array_length(T (&)[N]) { return N; }

#endif
