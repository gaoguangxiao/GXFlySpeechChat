#
# Be sure to run `pod lib lint GXFlySpeechChat.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GXFlySpeechChat'
  s.version          = '0.1.0'
  s.summary          = 'A short description of GXFlySpeechChat.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'gaoguangxiao125@sina.com' => 'gaoguangxiao125@sina.com' }
  s.source           = { :git => 'https://github.com/gaoguangxiao/GXFlySpeechChat.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'GXFlySpeechChat/Classes/**/*'
  
  # 核心SDK
  # s.vendored_frameworks = 'GXFlySpeechChat/Classes/Frameworks/AIPIFlyMSC.framework'
  
  # 子模块配置（如果有多个组件）
  s.subspec 'Core' do |core|
    core.vendored_frameworks = ['GXFlySpeechChat/Frameworks/AIPIFlyMSC.framework',
        'GXFlySpeechChat/Frameworks/AIPIFlyIVW.framework']
  end
  
  
  # c++'  # 标准方式，自动链接最新版本的 libc++
  s.libraries = 'c++'

  # 系统依赖
  s.frameworks = [
    'CoreGraphics',
    'SystemConfiguration',
    'CoreLocation'
  ]
  
  
  # s.resource_bundles = {
  #   'GXFlySpeechChat' => ['GXFlySpeechChat/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'MJExtension'
  s.dependency 'PTDebugView'
  s.dependency 'TKPermissionKit/Photo'
  s.dependency 'TKPermissionKit/Camera'
  s.dependency 'TKPermissionKit/Microphone'
  s.dependency 'TZImagePickerController' #照片选择器
end
