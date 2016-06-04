require 'bit_utils'

# Core Extension for Fixnum
class Fixnum
  def popcount
    BitUtils.popcount_fixnum self
  end
end

# Core Extension for Bignum
class Bignum
  def popcount
    BitUtils.popcount_bignum self
  end
end
