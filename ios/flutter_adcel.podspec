#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_adcel.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_adcel'
  s.version          = '1.5.12'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  
  s.dependency 'AdCel'
  
# insted of [s.dependency 'AdCel'] you can use any combination of next specs:
#  s.dependency 'AdCel/AdColony'
#  s.dependency 'AdCel/Applovin'
#  s.dependency 'AdCel/AmazonAd'
#  s.dependency 'AdCel/MyTarget'
#  s.dependency 'AdCel/MoPub'
#  s.dependency 'AdCel/Smaato'
#  s.dependency 'AdCel/StartApp'
#  s.dependency 'AdCel/Tapjoy'
#  s.dependency 'AdCel/Unity'
#  s.dependency 'AdCel/Vungle'
#  s.dependency 'AdCel/Inhouse'
#  s.dependency 'AdCel/Pangle'
#  s.dependency 'AdCel/Criteo'
#  s.dependency 'AdCel/AdMob' #optional
#  s.dependency 'AdCel/Facebook' #optional
#  s.dependency 'AdCel/Yandex' #optional
#  s.dependency 'AdCel/InMobi' #optional
  
  s.platform = :ios, '10.0'

  s.static_framework = true
  
  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
