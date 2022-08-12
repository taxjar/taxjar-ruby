# coding: utf-8

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'taxjar/version'

Gem::Specification.new do |spec|
  spec.name          = "taxjar-ruby"
  spec.version       = Taxjar::Version
  spec.authors       = ["TaxJar"]
  spec.email         = ["support@taxjar.com"]
  spec.summary       = "Ruby wrapper for Taxjar API"
  spec.description   = "Ruby wrapper for Taxjar API, more info at developers.taxjar.com"
  spec.homepage      = "http://developers.taxjar.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.7'

  spec.add_dependency 'addressable', '~> 2.3'
  spec.add_dependency 'http', '~> 5.0'
  spec.add_dependency 'memoizable', '~> 0.4.0'
  spec.add_dependency 'model_attribute', '~> 3.2'
  spec.add_development_dependency "bundler", ">= 1.7", "< 3.0"
  spec.add_development_dependency "rake", "~> 13.0"

  if spec.respond_to?(:metadata)
    spec.metadata['changelog_uri'] = 'https://github.com/taxjar/taxjar-ruby/blob/master/CHANGELOG.md'
    spec.metadata['source_code_uri'] = 'https://github.com/taxjar/taxjar-ruby'
    spec.metadata['bug_tracker_uri'] = 'https://github.com/taxjar/taxjar-ruby/issues'
  end
end
