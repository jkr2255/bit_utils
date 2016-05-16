#ifndef BIGNUM_IN_ULONG_H
#define BIGNUM_IN_ULONG_H 1

#ifdef HAVE_RB_ABSINT_NUMWORDS
#define BIGNUM_IN_ULONG(v) rb_absint_numwords(v, sizeof(unsigned long), NULL)
#else
size_t my_bignum_in_ulong(VALUE v);
#define BIGNUM_IN_ULONG(v) my_bignum_in_ulong(v)
#endif

#endif
