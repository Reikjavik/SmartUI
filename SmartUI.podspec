#
# Be sure to run `pod lib lint SmartUI.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SmartUI'
  s.version          = '0.4.0'
  s.summary          = 'SwiftUI inspired framework which uses the same syntax and provides support for iOS 10 and above'
  s.homepage         = 'https://github.com/Reikjavik/SmartUI'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Igor Tiukavkin' => 'in.tyukavkin@gmail.com' }
  s.source           = { :git => 'https://github.com/Reikjavik/SmartUI.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'
  s.swift_version    = '5.0'
  s.source_files = 'SmartUI/Sources/**/*'
end
