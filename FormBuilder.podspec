#
# Be sure to run `pod lib lint FormBuilder.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FormBuilder'
  s.version          = '0.1.0'
  s.summary          = 'A short description of FormBuilder.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://www.waterworld.com.hk'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Water Lou' => 'water@waterworld.com.hk' }
  #s.source           = { :git => 'git@git.waterworld.com.hk:FormBuilder', :tag => s.version.to_s }
  s.source           = { :git => 'git@git.waterworld.com.hk:FormBuilder' }
  s.social_media_url = 'https://twitter.com/waterlou'

  s.ios.deployment_target = '9.0'

  s.source_files = 'FormBuilder/FormBuilder/**/*.{swift}'
  s.resources = 'FormBuilder/FormBuilder/**/*.{xcassets, xib}'

  s.frameworks = 'UIKit'
end
