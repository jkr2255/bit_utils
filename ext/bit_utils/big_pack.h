#ifndef BIG_PACK_H
#define BIG_PACK_H 1

#ifdef HAVE_RB_BIG_PACK
#define BIG_PACK(val, ptr, cnt) rb_big_pack(val, ptr, cnt)
#elif defined(HAVE_RB_INTEGER_PACK)
#define BIG_PACK(val, ptr, cnt) rb_integer_pack(val, ptr, cnt, sizeof(long), 0, \
            INTEGER_PACK_LSWORD_FIRST|INTEGER_PACK_NATIVE_BYTE_ORDER| \
            INTEGER_PACK_2COMP)
#else
#error This Ruby is not supported.
#endif

#endif
