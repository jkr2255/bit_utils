#ifndef FUNCS_H_INCLUDED
#define FUNCS_H_INCLUDED 1

#include "ruby.h"

#ifdef HAVE_CPUID_H
#include <cpuid.h>
#endif

VALUE my_popcnt_p(VALUE self);

#ifdef HAVE_RB_BIG_PACK
#define BIG_PACK(val, ptr, cnt) rb_big_pack(val, ptr, cnt)
#elif defined(HAVE_RB_INTEGER_PACK)
#define BIG_PACK(val, ptr, cnt) rb_integer_pack(val, ptr, cnt, sizeof(long), 0, \
            INTEGER_PACK_LSWORD_FIRST|INTEGER_PACK_NATIVE_BYTE_ORDER| \
            INTEGER_PACK_2COMP)
#else
#error This Ruby is not supported.
#endif


#ifdef HAVE_RB_ABSINT_NUMWORDS
#define BIGNUM_IN_ULONG(v) rb_absint_numwords(v, sizeof(unsigned long), NULL)
#else
size_t my_bignum_in_ulong(VALUE v);
#define BIGNUM_IN_ULONG(v) my_bignum_in_ulong(v)
#endif

#endif
