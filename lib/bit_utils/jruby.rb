require 'java'

#
# module for bit utilities
#
module BitUtils

  #
  # module for Java-specific codes of BitUtils.
  # @note not intended for direct use.
  #
  module JavaImpl
    def count_fixnum(num)
      raise TypeError unless num.is_a?(::Fixnum)
      count = Java::JavaLang::Long.bitCount(num)
      num >= 0 ? count : count - 64
    end

    def count_bignum(num)
      raise TypeError unless num.is_a?(::Bignum)
      count = num.to_java.bitCount
      num >= 0 ? count : -count
    end

    def trailing_zeros_fixnum(num)
      raise TypeError unless num.is_a?(::Fixnum)
      return -1 if num == 0
      Java::JavaLang::Long.numberOfTrailingZeros(num)
    end

    def trailing_zeros_bignum(num)
      raise TypeError unless num.is_a?(::Bignum)
      num.to_java.getLowestSetBit
    end
  end

  extend JavaImpl

end
