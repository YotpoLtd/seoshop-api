# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'seoshop-api/version'

Gem::Specification.new do |spec|
  spec.name          = "seoshop-api"
  spec.version       = Seoshop::VERSION
  spec.authors       = ["Nimrod Popper"]
  spec.email         = ["nimrod@yotpo.com"]
  spec.description   = %q{Ruby wrapper for SEOshop API - written by Yotpo}
  spec.summary       = %q{Ruby wrapper for SEOshop API - written by Yotpo}
  spec.homepage      = "https://github.com/YotpoLtd/seoshop-api"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'pry'

  spec.add_dependency 'oauth2'
  spec.add_dependency 'faraday'
  spec.add_dependency 'typhoeus'
  spec.add_dependency 'faraday_middleware', '0.9.0'
  spec.add_dependency 'rash'
  spec.add_dependency 'oj'
  spec.add_dependency 'activesupport'
end
