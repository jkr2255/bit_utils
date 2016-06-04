require 'bit_utils'

# Core Extension for Fixnum
class Fixnum
  def each_bit(&block)
    BitUtils.each_bit_fixnum self, &block
  end
end

# Core Extension for Bignum
class Bignum
  def each_bit(&block)
    BitUtils.each_bit_bignum self, &block
  end
end
