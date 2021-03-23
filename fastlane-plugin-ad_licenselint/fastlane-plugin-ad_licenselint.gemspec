# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/ad_licenselint/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-ad_licenselint'
  spec.version       = Fastlane::AdLicenselint::VERSION
  spec.author        = 'Pierre Felgines'
  spec.email         = 'pierre.felgines@fabernovel.com'

  spec.summary       = 'Lint the licenses for iOS projects'
  spec.description   = 'Lint the licenses for iOS projects'
  spec.homepage      = "https://github.com/faberNovel/ad_licenselint"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  # Don't add a dependency to fastlane or fastlane_re
  # since this would cause a circular dependency

  spec.add_dependency 'ad_licenselint', '~> 1.1'

  spec.add_development_dependency('pry')
  spec.add_development_dependency('bundler')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('rspec_junit_formatter')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('simplecov')
  spec.add_development_dependency('fastlane', '>= 2.154.0')
end
