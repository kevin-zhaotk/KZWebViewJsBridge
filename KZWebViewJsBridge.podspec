#
#  Be sure to run `pod spec lint KZWebViewJsBridge.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #


  s.name         = "KZWebViewJsBridge"
  s.version      = "1.1.0"
  s.summary      = "A short description of KZWebViewJsBridge."


  s.homepage     = "https://github.com/kevin-zhaotk/KZWebViewJsBridge"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.license      = "BSD 3-Clause \"New\" License"

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.author             = { "zhaotongkai" => "zhaotonkgai@jianlc.com" }


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #


  s.source       = { :git => "https://github.com/kevin-zhaotk/KZWebViewJsBridge.git", :tag => "#{s.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source_files  = "KZWebViewJsBridge", "KZWebViewJsBridge/**/*.{h,m}", "KZWebViewJsBridge/**/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"

  s.ios.deployment_target = '8.0'
end
