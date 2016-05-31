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

    extend self

    def popcount(num)
      case num
      when Fixnum
        popcount_fixnum num
      when Bignum
        popcount_bignum num
      else
        raise TypeError
      end
    end

    def popcount_fixnum(num)
      raise TypeError unless num.is_a?(::Fixnum)
      count = Java::JavaLang::Long.bitCount(num)
      num >= 0 ? count : count - 64
    end

    def popcount_bignum(num)
      raise TypeError unless num.is_a?(::Bignum)
      count = num.to_java.bitCount
      num >= 0 ? count : -count
    end

    def trailing_zeros(num)
      case num
      when Fixnum
        trailing_zeros_fixnum num
      when Bignum
        trailing_zeros_bignum num
      else
        raise TypeError
      end
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
