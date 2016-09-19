require 'bit_utils'


# Core Extension for Integer
class Integer
  def popcount
    BitUtils.popcount self
  end
end

unless BitUtils::INTEGER_UNITED

  # Core Extension for Fixnum
  class Fixnum
    def popcount
      BitUtils.popcount_fixnum self
    end
  end

end
