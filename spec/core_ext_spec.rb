require 'spec_helper'
require 'bit_utils/core_ext'

# For unified Integer (Ruby >= 2.4)
describe Integer do
  it '#each_bit for Fixnum works' do
    expect(1.each_bit.to_a).to eq [0]
  end

  it '#each_bit for Bignum works' do
    expect((2**1000).each_bit.to_a).to eq [1000]
  end

  it '#popcount for Fixnum works' do
    expect(1.popcount).to eq 1
  end

  it '#popcount for Bignum works' do
    expect((2**1000).popcount).to eq 1
  end

  it '#trailing_zeros for Fixnum works' do
    expect(2.trailing_zeros).to eq 1
  end

  it '#trailing_zeros for Bignum works' do
    expect((2**1000).trailing_zeros).to eq 1000
  end
end
