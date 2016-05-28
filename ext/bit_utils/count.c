#include "count.h"

static VALUE bitutils_cimpl_count_fixnum(VALUE self, VALUE num){
    long l_num = NUM2LONG(num);
    int val = POPCOUNTL(l_num);
    if(l_num < 0) val -= sizeof(long) * CHAR_BIT;
    return INT2FIX(val);
}

#ifdef HAVE_POPCNT_GCC_ASM
static VALUE bitutils_cimpl_count_fixnum_asm(VALUE self, VALUE num){
    long l_num = NUM2LONG(num);
    long val;
    __asm__ volatile ("POPCNT %1, %0;": "=r"(val): "r"(l_num) : );
    if(l_num < 0) val -= sizeof(long) * CHAR_BIT;
    return LONG2FIX(val);
}
#define ASM_POPCOUNT 1
#else
static VALUE bitutils_cimpl_count_fixnum_asm(VALUE self, VALUE num){
    /* dummy function for C compiler, never called from Ruby */
    return Qnil;
}
#define ASM_POPCOUNT 0
#endif

/*  for bignum */
static VALUE bitutils_cimpl_count_bignum(VALUE self, VALUE num){
    int negated = 0;
    unsigned long * packed;
    VALUE abs_num;
    size_t words, i;
    LONG_LONG ret = 0;
    if(FIXNUM_P(num)){
        return bitutils_cimpl_count_fixnum(self, num);
    }
    Check_Type(num, T_BIGNUM);
    if(RBIGNUM_NEGATIVE_P(num)){
        negated = 1;
        abs_num = BIG_NEG(num);
    }else{
        abs_num = num;
    }
    words = BIGNUM_IN_ULONG(abs_num);
    if(words < ALLOCA_THRESHOLD){
        packed = ALLOCA_N(unsigned long, words);
    }else{
        packed = ALLOC_N(unsigned long, words);
    }
    BIG_PACK(abs_num, packed, words);
    for(i = 0; i < words; ++i){
        ret += POPCOUNTL(packed[i]);
    }
    if(negated) ret = -ret;
    if(words >= ALLOCA_THRESHOLD) xfree(packed);
    return LL2NUM(ret);
}

#if defined(HAVE_POPCNT_GCC_ASM) && defined(HAVE_POPCNT_LL_GCC_ASM) && (SIZEOF_LONG_LONG == SIZEOF_LONG * 2)
/* for Windows */
union ull_punning{
    unsigned long long ull;
    unsigned long ul[2];
};

static VALUE bitutils_cimpl_count_bignum_asm(VALUE self, VALUE num){
    int negated = 0;
    unsigned long * packed;
    union ull_punning * ull_packed;
    unsigned long long ull_o = 0, ull_o2 = 0;
    unsigned long long ull_i, ull_i2;
    VALUE abs_num;
    size_t words, i, ull_dwords;
    LONG_LONG ret = 0, ret2 = 0;
    if(FIXNUM_P(num)){
        return bitutils_cimpl_count_fixnum_asm(self, num);
    }
    Check_Type(num, T_BIGNUM);
    if(RBIGNUM_NEGATIVE_P(num)){
        negated = 1;
        abs_num = BIG_NEG(num);
    }else{
        abs_num = num;
    }
    words = BIGNUM_IN_ULONG(abs_num);
    if(words < ALLOCA_THRESHOLD){
        packed = ALLOCA_N(unsigned long, words);
    }else{
        packed = ALLOC_N(unsigned long, words);
    }
    BIG_PACK(abs_num, packed, words);
    ull_dwords = words / 4;
    ull_packed = (union ull_punning *) packed;
    for(i = 0; i < ull_dwords * 2; i += 2){
        ull_i = ull_packed[i].ull;
        ull_i2 = ull_packed[i+1].ull;
        __asm__ volatile ("POPCNT %1, %0;": "=r"(ull_o): "r"(ull_i) : );
        __asm__ volatile ("POPCNT %1, %0;": "=r"(ull_o2): "r"(ull_i2) : );
        ret += ull_o;
        ret2 += ull_o2;
    }
    ret += ret2;
    for(i *= 2; i < words; ++i){
        unsigned long ul_out = 0;
        __asm__ volatile ("POPCNT %1, %0;": "=r"(ul_out): "r"(packed[i]) : );
        ret += ul_out;
    }
    if(negated) ret = -ret;
    if(words >= ALLOCA_THRESHOLD) xfree(packed);
    return LL2NUM(ret);
}

#elif defined(HAVE_POPCNT_GCC_ASM)
static VALUE bitutils_cimpl_count_bignum_asm(VALUE self, VALUE num){
    int negated = 0;
    unsigned long * packed;
    unsigned long ul_i, ul_o = 0;
    unsigned long ul_i2, ul_o2 = 0;
    VALUE abs_num;
    size_t words, dwords, i;
    LONG_LONG ret = 0, ret2 = 0;
    if(FIXNUM_P(num)){
        return bitutils_cimpl_count_fixnum_asm(self, num);
    }
    Check_Type(num, T_BIGNUM);
    if(RBIGNUM_NEGATIVE_P(num)){
        negated = 1;
        abs_num = BIG_NEG(num);
    }else{
        abs_num = num;
    }
    words = BIGNUM_IN_ULONG(abs_num);
    if(words < ALLOCA_THRESHOLD){
        packed = ALLOCA_N(unsigned long, words);
    }else{
        packed = ALLOC_N(unsigned long, words);
    }
    BIG_PACK(abs_num, packed, words);
    dwords = words / 2;
    for(i = 0; i < dwords * 2; i += 2){
        ul_i = packed[i];
        ul_i2 = packed[i+1];
        __asm__ volatile ("POPCNT %1, %0;": "=r"(ul_o): "r"(ul_i) : );
        __asm__ volatile ("POPCNT %1, %0;": "=r"(ul_o2): "r"(ul_i2) : );
        ret += ul_o;
        ret2 += ul_o2;
    }
    ret += ret2;
    if(words & 1){
        __asm__ volatile ("POPCNT %1, %0;": "=r"(ul_o): "r"(packed[i]) : );
        ret += ul_o;
    }
    if(negated) ret = -ret;
    if(words >= ALLOCA_THRESHOLD) xfree(packed);
    return LL2NUM(ret);
}
#else
static VALUE bitutils_cimpl_count_bignum_asm(VALUE self, VALUE num){
    /* dummy function for C compiler, never called from Ruby */
    return Qnil;
}

#endif


void register_count(VALUE mod){
    VALUE have_cpu_popcnt;
    have_cpu_popcnt = my_popcnt_p(mod);
    if(ASM_POPCOUNT && have_cpu_popcnt){
        rb_define_method(mod, "count_fixnum", bitutils_cimpl_count_fixnum_asm, 1);
        rb_define_method(mod, "count_bignum", bitutils_cimpl_count_bignum_asm, 1);
        rb_define_method(mod, "count", bitutils_cimpl_count_bignum_asm, 1);
    }else{
        rb_define_method(mod, "count_fixnum", bitutils_cimpl_count_fixnum, 1);
        rb_define_method(mod, "count_bignum", bitutils_cimpl_count_bignum, 1);
        rb_define_method(mod, "count", bitutils_cimpl_count_bignum, 1);
    }
}
