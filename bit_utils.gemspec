# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bit_utils/version'

Gem::Specification.new do |spec|
  spec.name          = 'bit_utils'
  spec.version       = BitUtils::VERSION
  spec.authors       = %w[Jkr2255]
  spec.email         = %w[magnesium.oxide.play@gmail.com]

  spec.summary       = 'Utility methods for manipulating bits within Integer.'
  spec.homepage      = 'https://github.com/jkr2255/bit_utils'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]

if RUBY_PLATFORM =~ /java/
  spec.platform      = 'java'
else
  spec.extensions    = %w[ext/bit_utils/extconf.rb]
end

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rake-compiler'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
