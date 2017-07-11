#
#  Be sure to run `pod spec lint DHImageShearViewController.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
s.name         = "DHImageShearViewController"
s.version      = "1.0.1"
s.summary      = "图片剪切"
s.description  = <<-DESC
方便实现图片剪切功能
DESC
s.homepage     = "https://github.com/DajuanM/DHImageShearViewController"
s.license      = "MIT"
s.author       = { "Aiden" => "252289287@qq.com" }
s.source       = { :git => "https://github.com/DajuanM/DHImageShearViewController.git", :tag => "#{s.version}" }
s.source_files  = "DHImageShearViewController","DHImageShearViewController/**/*.{h,m}"
s.requires_arc = true
s.ios.deployment_target = '8.0'
s.dependency "Masonry"
end
