#ifndef TRAILING_ZEROS_H
#define TRAILING_ZEROS_H 1

#include "ruby.h"
#include "count.h"
#include "funcs.h"

void register_trailing_zeros(VALUE mod);

#ifdef HAVE___BUILTIN_CTZL
#  define CTZL(val) __builtin_ctzl(val)
#else
  static inline int CTZL(unsigned long val){
    return POPCOUNTL((val & (-val)) - 1);
  }
#endif

#endif
