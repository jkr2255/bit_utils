require 'spec_helper'

describe BitUtils do
  it 'has a version number' do
    expect(BitUtils::VERSION).not_to be nil
  end

  describe '#popcount' do
    it 'is a module function' do
      expect(BitUtils.methods).to include(:popcount)
      expect(BitUtils.singleton_methods).to include(:popcount)
    end

    it 'raises TypeError if other than Integer was passed' do
      expect { BitUtils.popcount(2.0) }.to raise_error(TypeError)
      expect { BitUtils.popcount(nil) }.to raise_error(TypeError)
    end

    expecteds = {
      0 => 0,
      1 => 1,
      0xf0 => 4,
      # threshold in 32-bit Fixnum
      0x3fff_ffff => 30,
      0x4000_0000 => 1,
      # threshold in 64-bit fixnum
      0x3fff_ffff_ffff_ffff => 62,
      0x4000_0000_0000_0000 => 1,
      # Bignum
      0x3333_3333_3333_3333_3333_3333 => 48,
      # Really big value
      (2 ** 10000) - 1 => 10000,
      # negative
      -1 => 0,
      -2 => -1,
      -0x10 => -4,
      # threshold in 32-bit Fixnum
      -0x4000_0000 => -30,
      -0x4000_0001 => -1,
      # threshold in 64-bit fixnum
      -0x4000_0000_0000_0000 => -62,
      -0x4000_0000_0000_0001 => -1,
      # Bignum
      -0x3333_3333_3333_3333_3333_3334 => -48,
      # Really big value
      -(2 ** 10000) => -10000,
    }

    expecteds.each_pair do |num, cnt|
      it "returns #{cnt} when #{num} is given" do
        expect(BitUtils.popcount(num)).to eq cnt
      end
    end
  end

  describe '#trailing_zeros' do
    it 'is a module function' do
      expect(BitUtils.methods).to include(:trailing_zeros)
      expect(BitUtils.singleton_methods).to include(:trailing_zeros)
    end

    it 'raises TypeError if other than Integer was passed' do
      expect { BitUtils.trailing_zeros(2.0) }.to raise_error(TypeError)
      expect { BitUtils.trailing_zeros(nil) }.to raise_error(TypeError)
    end

    expecteds = {
      # irregular case
      0 => -1,
      # positive
      1 => 0,
      2 => 1,
      4 => 2,
      6 => 1,
      1024 => 10,
      # threshold in 32-bit Fixnum
      0x3fff_ffff => 0,
      0x4000_0000 => 30,
      # threshold in 64-bit fixnum
      0x3fff_ffff_ffff_ffff => 0,
      0x4000_0000_0000_0000 => 62,
      # really big number
      (15 << 1_000) => 1000,
      # negative
      -1 => 0,
      -2 => 1,
      -4 => 2,
      -6 => 1,
      # threshold in 32-bit Fixnum
      -0x4000_0000 => 30,
      -0x4000_0001 => 0,
      # threshold in 64-bit fixnum
      -0x4000_0000_0000_0000 => 62,
      -0x4000_0000_0000_0001 => 0,
      # Really big value
      -(2 ** 1_000) => 1_000,
    }
    expecteds.each_pair do |num, cnt|
      it "returns #{cnt} when #{num} is given" do
        expect(BitUtils.trailing_zeros(num)).to eq cnt
      end
    end
  end

  describe '#each_bit' do
    context '(irregular values)' do
      it 'raises TypeError when non-Integer given' do
        expect { BitUtils.each_bit('foo') }.to raise_error(TypeError)
        expect { BitUtils.each_bit(1.8) }.to raise_error(TypeError)
      end

      it 'raises RangeError when negative value given' do
        expect { BitUtils.each_bit(-1) }.to raise_error(RangeError)
        expect { BitUtils.each_bit(-(2**1_000)) }.to raise_error(RangeError)
      end
    end

    it 'returns Enumerator if block was not given' do
      expect(BitUtils.each_bit(0)).to be_a(Enumerator)
      expect(BitUtils.each_bit(1)).to be_a(Enumerator)
      expect(BitUtils.each_bit(2**300)).to be_a(Enumerator)
    end

    it 'yields with bit position' do
      expect { |b| BitUtils.each_bit(1, &b) }.to yield_with_args(0)
      expect { |b| BitUtils.each_bit(4, &b) }.to yield_with_args(2)
      expect { |b| BitUtils.each_bit(1 << 100, &b) }.to yield_with_args(100)
    end

    it 'yields with all bits' do
      expect(BitUtils.each_bit(0).to_a).to match_array([])
      expect(BitUtils.each_bit(1).to_a).to match_array([0])
      expect(BitUtils.each_bit(2).to_a).to match_array([1])
      expect(BitUtils.each_bit(3).to_a).to match_array([0, 1])
      expect(BitUtils.each_bit(0x3fff_ffff).to_a).to match_array([*0..29])
      expect(BitUtils.each_bit(0x4000_0000).to_a).to match_array([30])
      expect(BitUtils.each_bit(0x3fff_ffff_ffff_ffff).to_a).to match_array([*0..61])
      expect(BitUtils.each_bit(0x4000_0000_0000_0000).to_a).to match_array([62])
      expect(BitUtils.each_bit((1 << 10_000) - 1).to_a).to match_array([*0..9_999])
      expect(BitUtils.each_bit(1 << 10_000).to_a).to match_array([10_000])
    end
  end
end
