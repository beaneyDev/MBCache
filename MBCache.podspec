#
# Be sure to run `pod lib lint MBCache.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MBCache'
  s.version          = '0.1.0'
  s.summary          = 'An image extension for persistence caching (along with animations for presenting the image)'

  s.description      = 'A UIImage extension that takes care of downloading and caching an image, allowing the user to supply a placeholder image while the image downloads.'

  s.homepage         = 'https://github.com/beaney1232/MBCache'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'beaney1232' => 'matt.beaney@pagesuite.co.uk' }
  s.source           = { :git => 'https://github.com/beaney1232/MBCache.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'MBCache/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MBCache' => ['MBCache/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'

    s.dependency 'CryptoSwift'
    s.dependency 'MBUtils'
end
