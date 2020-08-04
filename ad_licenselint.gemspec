Gem::Specification.new do |s|
  s.name        = 'ad_licenselint'
  s.version     = '0.0.0'
  s.executables << 'ad_licenselint'
  s.date        = '2020-08-04'
  s.summary     = "Lint the licenses for iOS projects"
  s.description = "Lint the licenses for iOS projects"
  s.authors     = ["Pierre Felgines"]
  s.email       = 'pierre.felgines@fabernovel.com'
  s.files       = [
    "lib/ad_licenselint.rb",
    "lib/ad_licenselint/ad_logger.rb",
    "lib/ad_licenselint/option_handler.rb",
    "lib/ad_licenselint/runner.rb",
    "lib/ad_licenselint/license_entry.rb",
    "lib/ad_licenselint/constant.rb",
  ]
  s.homepage    = 'https://rubygems.org/gems/ad_licenselint'
  s.license     = 'MIT'

  s.add_development_dependency 'bundler', '>= 1.12.0', '< 3.0.0'
  s.add_development_dependency 'rake', '~> 12.3'
  s.add_development_dependency 'minitest', '~> 5.11'
  s.add_development_dependency 'byebug', '~> 11.0'
  s.add_development_dependency 'minitest-reporters', '~> 1.3'

  s.add_dependency 'colorize', '~> 0.8'
  s.add_dependency 'terminal-table', '~> 1.8'

  s.required_ruby_version = '~> 2.3'
end