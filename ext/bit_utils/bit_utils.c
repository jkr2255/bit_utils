#include "bit_utils.h"

VALUE rb_mBitUtils;

void
Init_bit_utils(void)
{
  rb_mBitUtils = rb_define_module("BitUtils");
}
