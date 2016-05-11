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

end
