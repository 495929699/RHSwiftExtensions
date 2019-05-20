#
# Be sure to run `pod lib lint RHSwiftExtensions.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RHSwiftExtensions'
  s.version          = '1.2.3'
  s.summary          = 'Swift 常用功能封装'

  s.description      = <<-DESC
  Swift 常用功能封装
                       DESC

  s.homepage         = 'https://github.com/495929699/RHSwiftExtensions'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'rongheng' => '495929699g@gmail.com' }
  s.source           = { :git => 'https://github.com/495929699/RHSwiftExtensions.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'
  s.cocoapods_version = '>=1.6.0'
  s.pod_target_xcconfig = {
    'SWIFT_VERSION' => '5.0'
  }
  
  s.source_files = 'RHSwiftExtensions/Classes/*.swift', 'RHSwiftExtensions/Classes/**/*.swift'
#  s.dependency 'RxCocoa'
#  s.dependency 'RxSwift', '~>4.5'
#  s.dependency 'Alamofire', '~>4.8.2'
#  s.dependency 'Moya', '~>13.0'
#  s.dependency 'RHCache', '~>0.1'

  # 子模块b模板
  #  s.default_subspec  = 'Core'
  #  s.subspec 'Core' do |ss|
  #    ss.source_files  = 'Sources/Moya/', 'Sources/Moya/Plugins/'
  #    ss.dependency 'Alamofire', '~> 4.1'
  #    ss.dependency 'Result', '~> 4.1'
  #    ss.framework  = 'Foundation'

end
