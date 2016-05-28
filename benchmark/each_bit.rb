require 'bit_utils'
require 'benchmark'

puts 'Fixnum'
value = 0x1F3C_0A27
times = 1_000_000
Benchmark.bm 10 do |r|
  r.report "Pure Ruby" do
    times.times do
      BitUtils::PureRuby.each_bit_fixnum(value).to_a
    end
  end
  r.report "Optimized" do
    times.times do
      BitUtils.each_bit(value).to_a
    end
  end
end

puts

patterns = [
    {value: (2**128) - (2**32), repeat: 100_000, title: '128-bit Bignum' },
    {value: (2**999) + (2**32), repeat: 100_000, title: '1000-bit Bignum (sparse)' },
    {value: (2**1000) - (2**40), repeat: 10_000, title: '1000-bit Bignum' },
]


patterns.each do |h|
  puts h[:title]
  value = h[:value]
  times =
  Benchmark.bm 10 do |r|
    r.report "Pure Ruby" do
      h[:repeat].times do
        BitUtils::PureRuby.each_bit_bignum(value).to_a
      end
    end
    r.report "Optimized" do
      h[:repeat].times do
        BitUtils.each_bit(value).to_a
      end
    end
  end
  puts
end

