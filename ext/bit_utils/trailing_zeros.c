#include "trailing_zeros.h"

#define VAL_CTZL(n) INT2FIX((n) ? CTZL(n) : -1)

static VALUE bitutils_cimpl_trailing_zeros_fixnum(VALUE self, VALUE num){
    // using only bit pattern
    unsigned long ul_num = (unsigned long) NUM2LONG(num);
    return VAL_CTZL(ul_num);
}

static VALUE bitutils_cimpl_trailing_zeros_bignum(VALUE self, VALUE num){
    unsigned long * packed;
    size_t words, i, ret;
    if(FIXNUM_P(num)){
        unsigned long ul_num = (unsigned long) FIX2LONG(num);
        return VAL_CTZL(ul_num);
    }
    Check_Type(num, T_BIGNUM);
    if(rb_big_cmp(num, INT2FIX(0)) == 0) return INT2FIX(-1);
    words = BIGNUM_IN_ULONG(num);
    if(words < ALLOCA_THRESHOLD){
        packed = ALLOCA_N(unsigned long, words);
    }else{
        packed = ALLOC_N(unsigned long, words);
    }
    BIG_PACK(num, packed, words);
    for( i= 0; !packed[i] ;++i){
        /* do nothing */
    }
    ret = i * sizeof(long) * CHAR_BIT + CTZL(packed[i]);
    if(words >= ALLOCA_THRESHOLD) xfree(packed);
    return SIZET2NUM(ret);
}

void register_trailing_zeros(VALUE mod){
    rb_define_module_function(mod, "trailing_zeros_fixnum", bitutils_cimpl_trailing_zeros_fixnum, 1);
    rb_define_module_function(mod, "trailing_zeros_bignum", bitutils_cimpl_trailing_zeros_bignum, 1);
    rb_define_module_function(mod, "trailing_zeros", bitutils_cimpl_trailing_zeros_bignum, 1);
}
