require 'bit_utils'

# Core Extension for Fixnum
class Fixnum
  def trailing_zeros
    BitUtils.trailing_zeros_fixnum self
  end
end

# Core Extension for Bignum
class Bignum
  def trailing_zeros
    BitUtils.trailing_zeros_bignum self
  end
end
