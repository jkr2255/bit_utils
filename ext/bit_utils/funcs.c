#include "funcs.h"

#if SIZEOF_LONG == 8
int my_popcountl(unsigned long x){
    x = ((x & 0xaaaaaaaaaaaaaaaaUL) >> 1)
      +  (x & 0x5555555555555555UL);
    x = ((x & 0xccccccccccccccccUL) >> 2)
      +  (x & 0x3333333333333333UL);
    x = ((x & 0xf0f0f0f0f0f0f0f0UL) >> 4)
      +  (x & 0x0f0f0f0f0f0f0f0fUL);
    x = ((x & 0xff00ff00ff00ff00UL) >> 8)
      +  (x & 0x00ff00ff00ff00ffUL);
    x = ((x & 0xffff0000ffff0000UL) >> 16)
      +  (x & 0x0000ffff0000ffffUL);
    x = ((x & 0xffffffff00000000UL) >> 32)
      +  (x & 0x00000000ffffffffUL);
    return (int) x;
}
#elif SIZEOF_LONG == 4
int my_popcountl(unsigned long x){
    x = ((x & 0xaaaaaaaaUL) >> 1)
      +  (x & 0x55555555UL);
    x = ((x & 0xccccccccUL) >> 2)
      +  (x & 0x33333333UL);
    x = ((x & 0xf0f0f0f0UL) >> 4)
      +  (x & 0x0f0f0f0fUL);
    x = ((x & 0xff00ff00UL) >> 8)
      +  (x & 0x00ff00ffUL);
    x = ((x & 0xffff0000UL) >> 16)
      +  (x & 0x0000ffffUL);
    return (int) x;
}
#else
#error Unsupported architecture
#endif

size_t my_bignum_in_ulong(VALUE v){
    static ID size_id = 0;
    VALUE ret_val;
    if(!size_id){
        size_id = rb_intern("size");
    }
    ret_val = rb_funcall(v, size_id, 0);
    return (NUM2SIZET(ret_val) + sizeof(unsigned long) - 1) / sizeof(unsigned long);
}

#ifdef HAVE___GET_CPUID
VALUE my_popcnt_p(VALUE self){
    unsigned int eax, ebx, ecx = 0, edx;
    __get_cpuid(1, &eax, &ebx, &ecx, &edx);
    return (ecx & bit_POPCNT) ? Qtrue : Qfalse;
}
#else
VALUE my_popcnt_p(VALUE self){
    return Qfalse;
}
#endif
