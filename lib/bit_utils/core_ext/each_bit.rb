require 'bit_utils'

# Core Extension for Integer
class Integer
  def each_bit(&block)
    BitUtils.each_bit self, &block
  end
end

unless BitUtils::INTEGER_UNITED

  # Core Extension for Fixnum
  class Fixnum
    def each_bit(&block)
      BitUtils.each_bit_fixnum self, &block
    end
  end

end
