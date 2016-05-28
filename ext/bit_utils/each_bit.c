#include "each_bit.h"

static const char * mes = "Negative value is not accepted";

static VALUE bitutils_cimpl_each_bit_fixnum(VALUE self, VALUE num){
    long l_num = NUM2LONG(num);
    unsigned long ul_num = (unsigned long) l_num;
    int shifted = 0, pos;

    if(l_num < 0){
        rb_raise(rb_eRangeError, mes);
    }

    RETURN_ENUMERATOR(self, 1, &num);

    while(ul_num){
        pos = CTZL(ul_num);
        rb_yield(INT2FIX(pos + shifted));
        ++pos;
        ul_num >>= pos;
        shifted += pos;
    }
    return Qnil;
}

static VALUE bitutils_cimpl_each_bit_bignum(VALUE self, VALUE num){
    unsigned long * packed;
    long long_num = 0;
    unsigned long line, one_line;
    int is_fixnum = 0;
    size_t words, i;
    VALUE tmp_buf = Qnil;
    if(FIXNUM_P(num)){
        is_fixnum = 1;
        long_num = FIX2LONG(num);
    }else{
        Check_Type(num, T_BIGNUM);
    }

    if(long_num < 0 || (is_fixnum == 0 && RBIGNUM_NEGATIVE_P(num))){
        rb_raise(rb_eRangeError, mes);
    }

    RETURN_ENUMERATOR(self, 1, &num);

    if(is_fixnum){
        one_line = (unsigned long) long_num;
        packed = &one_line;
        words = 1;
    }else{
        words = BIGNUM_IN_ULONG(num);
        if(words < ALLOCA_THRESHOLD){
            packed = ALLOCA_N(unsigned long, words);
        }else{
            packed = rb_alloc_tmp_buffer(&tmp_buf, sizeof(unsigned long) * words);
        }
        BIG_PACK(num, packed, words);
    }

    for(i = 0; i < words; ++i){
        int shifted = 0, pos;
        line = packed[i];
        while(line){
            pos = CTZL(line);
            rb_yield(INT2FIX(pos + shifted + i * sizeof(unsigned long) * CHAR_BIT));
            ++pos;
            line >>= pos;
            shifted += pos;
        }
    }

    if(tmp_buf != Qnil){
        rb_free_tmp_buffer(&tmp_buf);
    }
    return Qnil;
}

void register_each_bit(VALUE mod){
    rb_define_method(mod, "each_bit_fixnum", bitutils_cimpl_each_bit_fixnum, 1);
    rb_define_method(mod, "each_bit_bignum", bitutils_cimpl_each_bit_bignum, 1);
    rb_define_method(mod, "each_bit", bitutils_cimpl_each_bit_bignum, 1);
}
