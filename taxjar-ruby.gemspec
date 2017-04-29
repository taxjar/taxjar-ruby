# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'taxjar/version'

Gem::Specification.new do |spec|
  spec.name          = "taxjar-ruby"
  spec.version       = Taxjar::Version
  spec.authors       = ["TaxJar"]
  spec.email         = ["support@taxjar.com"]
  spec.summary       = %q{Ruby wrapper for Taxjar API}
  spec.description   = %q{Ruby wrapper for Taxjar API, more info at developers.taxjar.com}
  spec.homepage      = "http://developers.taxjar.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9.3'

  spec.add_dependency 'addressable', '~> 2.3'
  spec.add_dependency 'http', '~> 0.9.4'
  spec.add_dependency 'memoizable', '~> 0.4.0'
  spec.add_dependency 'taxjar-model_attribute', '~> 3.1'
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
