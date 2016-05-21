require 'bit_utils'
require 'benchmark'

puts 'Fixnum'
value = 0x1000_0000
times = 1_000_000
Benchmark.bm 10 do |r|
  r.report "Pure Ruby" do
    times.times do
      BitUtils::PureRuby.trailing_zeros_fixnum value
    end
  end
  r.report "Optimized" do
    times.times do
      BitUtils.trailing_zeros value
    end
  end
end
puts

patterns = [
    {value: (2**128) - (2**32), repeat: 1_000_000, title: '128-bit Bignum' },
    {value: (2**999) + (2**32), repeat: 100_000, title: '1000-bit Bignum' },
]


patterns.each do |h|
  puts h[:title]
  value = h[:value]
  times =
  Benchmark.bm 10 do |r|
    r.report "Pure Ruby" do
      h[:repeat].times do
        BitUtils::PureRuby.trailing_zeros_bignum value
      end
    end
    r.report "Optimized" do
      h[:repeat].times do
        BitUtils.trailing_zeros value
      end
    end
  end
  puts
end

