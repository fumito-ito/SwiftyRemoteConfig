Pod::Spec.new do |spec|
  spec.name         = "SwiftyRemoteConfig"
  spec.version      = "0.1.1"
  spec.summary      = "Modern Swift API for FirebaseRemoteConfig"

  spec.description  = <<-DESC
  SwiftyRemoteConfig makes Firebase Remote Config enjoyable to use by combining expressive Swifty API with the benefits fo static typing. This library is strongly inspired by [SwiftyUserDefaults](https://github.com/sunshinejr/SwiftyUserDefaults).
                   DESC

  spec.homepage     = "https://github.com/fumito-ito/SwiftyRemoteConfig"
  spec.license      = { :type => "Apache2.0", :file => "LICENSE" }
  spec.authors            = { "Fumito Ito" => "weathercook@gmail.com" }
  spec.social_media_url   = "https://twitter.com/fumito_ito"

  spec.ios.deployment_target = "11.0"
  spec.osx.deployment_target = "10.12"
  spec.tvos.deployment_target = "12.0"
  spec.watchos.deployment_target = "6.0"
  spec.source       = { :git => "https://github.com/fumito-ito/SwiftyRemoteConfig.git", :tag => "#{spec.version}" }
  spec.source_files  = "Sources", "Sources/**/*.swift"
  spec.requires_arc = true
  spec.swift_version = "5.0", "5.1", "5.2"

  spec.static_framework = true
  spec.dependency "FirebaseRemoteConfig", "~> 8.8.0"

end
