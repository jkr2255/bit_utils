# BitUtils

[![Build Status](https://travis-ci.org/jkr2255/bit_utils.svg?branch=master)](https://travis-ci.org/jkr2255/bit_utils)

Utility methods for bit-wise operations of `Integer`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bit_utils'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bit_utils

## Usage

Module `BitUtils` appears after `require 'bit_utils'`.

Currently `BitUtils` offers three functionalities.

### `BitUtils.#popcount(num)`
Returns popcount (Hamming weight) of the `num`; i.e. equal to `num.to_s(2).count('1')` for non-negative numbers.

#### for negative numbers
Theoretically, Ruby treats negative integers as if *infinite* 1-bits are leaded (`printf '%x', -1` gives `..f` ),
so counting 1 bits for negative numbers is meaningless.

In this implementation, `popcount` for negative number counts *0* bits and negates the result. (distinguishing with positive version) Same in Ruby:
```rb
return -popcount(~num) if num < 0
```

Note that both `popcount(0)` and `popcount(-1)` still return 0.

### `BitUtils.#trailing_zeros(num)`
Returns the number of 0 bits continuing from least significant bit. If `num == 0`, it returns -1.

### `BitUtils.#each_bit(num, &block)`
Iterate over 1-bit positions in `Integer`. If block is not given, it returns `Enumerator`.

The yielding order is *unspecified*; may change by platform/version.

If negative `num` is given, it raises `RangeError`

### common to all functionalities
All of the module functions raise `TypeError` unless the parameter is `Integer`.

All module functions have `.#xxx_fixnum` and `.#xxx_bignum` (specific for `Fixnum` and `Bignum`), but these are not intended for direct use;
these will be removed in the future..


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Limitations
This gem is mainly developed on x64 GCC environment, so in other environments it may not work or be slow.

Pull requests for other environments are welcome.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jkr2255/bit_utils.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

