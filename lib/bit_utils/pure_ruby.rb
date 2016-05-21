#
# module for bit utilities
#
module BitUtils

  #
  # module for pure Ruby code of BitUtils.
  # @note not intended for direct use.
  #
  module PureRuby

    extend self

    def count_integer(num)
      raise TypeError unless num.is_a?(::Integer)
      return -count_integer(~num) if num < 0
      # puts 'pure ruby'
      num.to_s(2).count('1')
    end

    alias count_fixnum count_integer
    alias count_bignum count_integer

    def trailing_zeros_integer(num)
      raise TypeError unless num.is_a?(::Integer)
      return -1 if num == 0
      # puts 'pure ruby'
      (num & -num).bit_length - 1
    end

    alias trailing_zeros_fixnum trailing_zeros_integer
    alias trailing_zeros_bignum trailing_zeros_integer
  end

  extend PureRuby
end
