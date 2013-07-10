# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'funkify/version'

Gem::Specification.new do |spec|
  spec.name          = "funkify"
  spec.version       = Funkify::VERSION
  spec.authors       = ["John Mair"]
  spec.email         = ["jrmair@gmail.com"]
  spec.description   = "Haskell-style partial application and composition for Ruby methods"
  spec.summary       = "Haskell-style partial application and composition for Ruby methods"
  spec.homepage      = "https://github.com/banister/funkify"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'bacon', '~> 1.2'
end
