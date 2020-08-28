Pod::Spec.new do |spec|
  spec.name         = "SwiftyRemoteConfig"
  spec.version      = "0.0.1"
  spec.summary      = "Modern Swift API for FirebaseRemoteConfig"

  spec.description  = <<-DESC
  SwiftyRemoteConfig makes Firebase Remote Config enjoyable to use by combining expressive Swifty API with the benefits fo static typing. This library is strongly inspired by [SwiftyUserDefaults](https://github.com/sunshinejr/SwiftyUserDefaults).
                   DESC

  spec.homepage     = "http://github.com/fumito-ito/SwiftyRemoteConfig"
  spec.license      = { :type => "Apache2.0", :file => "LICENSE" }
  spec.authors            = { "Fumito Ito" => "weathercook@gmail.com" }
  spec.social_media_url   = "https://twitter.com/fumito_ito"

  spec.platform     = :ios
  spec.ios.deployment_target = "12.0"
  spec.source       = { :git => "http://github.com/fumito-ito/SwiftyRemoteConfig", :tag => "#{spec.version}" }
  spec.source_files  = "Sources", "Sources/**/*.swift"
  spec.public_header_files = "SwiftyRemoteConfig.h"
  spec.requires_arc = true

  spec.dependency "Firebase/RemoteConfig", "~> 6.29.0"

end
