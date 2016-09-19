require 'bit_utils'

# Core Extension for Integer
class Integer
  def trailing_zeros
    BitUtils.trailing_zeros self
  end
end

unless BitUtils::INTEGER_UNITED

  # Core Extension for Fixnum
  class Fixnum
    def trailing_zeros
      BitUtils.trailing_zeros_fixnum self
    end
  end

end
