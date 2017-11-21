#
# Be sure to run `pod lib lint CWProgressHUD.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CWProgressHUD'
  s.version          = '0.6.0'
  s.summary          = 'A quick and clean progress HUD.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A quick and clean progress HUD. Install library in order to display an interactive progress HUD to users to showcase that a time-consuming event is occuring such as loading some information.
                       DESC

  s.homepage         = 'https://github.com/ChrishonWyllie/CWProgressHUD'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ChrishonWyllie' => 'chrishon595@yahoo.com' }
  s.source           = { :git => 'https://github.com/ChrishonWyllie/CWProgressHUD.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.3'

  s.source_files = 'Classes/**/*'

  s.resource_bundles = {
     'CWProgressHUD' => ['Resources/*']
  }


  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
