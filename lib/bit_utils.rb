require 'bit_utils/version'

require 'bit_utils/pure_ruby'

if RUBY_PLATFORM =~ /java/
  require 'bit_utils/jruby_bit_length'
  require 'bit_utils/jruby'
else
  require 'backports/2.1.0/fixnum/bit_length'
  require 'backports/2.1.0/bignum/bit_length'
  require 'bit_utils/bit_utils'
  # require 'bit_utils/cruby'
end


module BitUtils

  module_function

  [:count, :trailing_zeros, :each_bit].each do |sym|
    next if BitUtils.respond_to?(sym)
    define_method sym, -> (num, &b) do
      case num
      when Fixnum
        send :"#{sym}_fixnum", num, &b
      when Bignum
        send :"#{sym}_bignum", num, &b
      else
        raise TypeError
      end
    end
  end
end
