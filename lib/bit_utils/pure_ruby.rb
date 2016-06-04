require 'function_module'

#
# module for bit utilities
#
module BitUtils

  #
  # module for pure Ruby code of BitUtils.
  # @note not intended for direct use.
  #
  module PureRuby

    module_function

    def popcount(num)
      raise TypeError unless num.is_a?(::Integer)
      return -popcount(~num) if num < 0
      num.to_s(2).count('1')
    end

    alias_module_function :popcount_fixnum, :popcount
    alias_module_function :popcount_bignum, :popcount

    def trailing_zeros(num)
      raise TypeError unless num.is_a?(::Integer)
      return -1 if num == 0
      (num & -num).bit_length - 1
    end

    alias_module_function :trailing_zeros_fixnum, :trailing_zeros
    alias_module_function :trailing_zeros_bignum, :trailing_zeros

    def each_bit(num)
      raise TypeError unless num.is_a?(::Integer)
      raise RangeError if num < 0
      return enum_for(__method__, num) { BitUtils.count(num) } unless block_given?
      shift = 0
      loop do
        return if num == 0
        pos = BitUtils.trailing_zeros num
        yield shift + pos
        num >>= pos + 1
        shift += pos + 1
      end
    end

    alias_module_function :each_bit_fixnum, :each_bit
    alias_module_function :each_bit_bignum, :each_bit

  end

  include_module_functions PureRuby
end
