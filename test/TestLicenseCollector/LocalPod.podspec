Pod::Spec.new do |s|
  s.name             = 'LocalPod'
  s.version          = '1.0'
  s.summary          = 'LocalPod'

  s.homepage         = 'https://domain.com'
  s.license          = { type: 'Commercial', text: 'Some Copyright 2019' }
  s.author           = { 'Author' => 'domain.com' }
  s.source           = { git: 'https://github.com/voidless/ad_licenselint.git', branch: 'master' }

  s.platform = :ios
  s.swift_version = '5.1'
  s.ios.deployment_target = '13.0'

  s.ios.source_files = 'TestLicenseCollector/ContentView.swift'

end
