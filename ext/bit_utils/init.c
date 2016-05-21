#include "bit_utils.h"

VALUE rb_mBitUtils;

void
Init_bit_utils(void)
{
  VALUE rb_mCImpl;
  rb_mBitUtils = rb_define_module("BitUtils");
  rb_mCImpl = rb_define_module_under(rb_mBitUtils, "CImpl");
  rb_extend_object(rb_mCImpl, rb_mCImpl);
  rb_extend_object(rb_mBitUtils, rb_mCImpl);
  register_count(rb_mCImpl);
  register_trailing_zeros(rb_mCImpl);
}
