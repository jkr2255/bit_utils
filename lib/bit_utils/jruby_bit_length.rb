require 'java'

# for Bignum

unless Bignum.method_defined?(:bit_length)
  class Bignum #:nodoc:
    def bit_length
      to_java.bitLength
    end
  end
end

# for Fixnum

unless Fixnum.method_defined?(:bit_length) && -1.bit_length == 0
  class Fixnum #:nodoc:
    def bit_length
      val = self < 0 ? ~self : self
      64 - Java::JavaLang::Long.numberOfLeadingZeros(val)
    end
  end
end

