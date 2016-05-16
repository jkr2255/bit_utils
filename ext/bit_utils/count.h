#ifndef COUNT_H_INCLUDED
#define COUNT_H_INCLUDED 1

#ifdef HAVE___BUILTIN_POPCOUNTL
#define POPCOUNTL(x) __builtin_popcountl(x)
#else
int my_popcountl(unsigned long x);
#define POPCOUNTL(x) my_popcountl(x)
#endif

#ifdef HAVE_RB_BIG_XOR
#define BIG_NEG(val) rb_big_xor(val, INT2FIX(-1))
#else
#define BIG_NEG(val) rb_funcall(val, rb_intern("~"), 0)
#endif

#define ALLOCA_THRESHOLD (1024 / sizeof(unsigned long))

#ifdef HAVE_CPUID_H
#include <cpuid.h>
#endif

void register_count(VALUE mod);

#endif
