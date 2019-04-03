#
# Be sure to run `pod lib lint RHSwiftExtensions.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RHSwiftExtensions'
  s.version          = '1.0'
  s.summary          = 'Swift 常用功能封装'

  s.description      = <<-DESC
  Swift 常用功能封装，RXSwift 扩展、Moya请求方法扩展
                       DESC

  s.homepage         = 'https://github.com/495929699/RHSwiftExtensions'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'rongheng' => '495929699g@gmail.com' }
  s.source           = { :git => 'https://github.com/495929699/RHSwiftExtensions.git', :tag => s.version.to_s }

  s.swift_version = '5.0'
  s.ios.deployment_target = '9.0'
  s.cocoapods_version = '1.6.0'
  # 对本pod（既 RHSwiftExtensions）的编译设置，此设置会在 trunk push 设置项目的此编译配置。原因是Cache三方库 在release下 SWIFT_OPTIMIZATION_LEVEL 设置为 -Osize 时会报错。设置其他模式就OK。-Onone 是不优化
  s.pod_target_xcconfig = { 'SWIFT_OPTIMIZATION_LEVEL' => '-Onone' }

  s.source_files = 'RHSwiftExtensions/Classes/*.swift', 'RHSwiftExtensions/Classes/**/*.swift'
  s.dependency 'RxCocoa'
  s.dependency 'RxSwift', '~>4.3.1'
  s.dependency 'Alamofire', '~>4.8.2'
  s.dependency 'Moya/RxSwift', '~>12.0.1'
  #s.dependency 'Cache' 等作者更新，就不用手动拖入项目了

end
