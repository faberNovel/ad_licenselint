Gem::Specification.new do |s|
  s.name        = 'ad_licenselint'
  s.version     = '1.4.0'
  s.executables << 'ad_licenselint'
  s.date        = '2020-08-04'
  s.summary     = "Lint the licenses for iOS projects"
  s.description = "Lint the licenses for iOS projects"
  s.authors     = ["Pierre Felgines"]
  s.email       = 'pierre.felgines@fabernovel.com'
  s.files       = Dir['lib/**/*.rb']
  s.homepage    = 'https://rubygems.org/gems/ad_licenselint'
  s.license     = 'MIT'

  s.add_development_dependency 'bundler', '>= 1.12.0', '< 3.0.0'
  s.add_development_dependency 'rake', '~> 12.3'
  s.add_development_dependency 'minitest', '~> 5.16'
  s.add_development_dependency 'byebug', '~> 11.0'
  s.add_development_dependency 'minitest-reporters', '~> 1.3'
  s.add_development_dependency 'minitest-hooks', '~> 1.5'

  s.add_dependency 'colorize', '~> 0.8'
  s.add_dependency 'terminal-table', '~> 1.8'
  s.add_dependency 'cocoapods', '~> 1.9'

  s.required_ruby_version = '>= 2.6'
end
