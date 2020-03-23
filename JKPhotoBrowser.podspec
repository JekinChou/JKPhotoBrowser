Pod::Spec.new do |s|
s.name         = "JKPhotoBrowser"
s.version      = "1.1.0.0"
s.summary      = "图片浏览器(仿微博)."
s.homepage     = "https://github.com/JekinChou/JKPhotoBrowser"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author       = { "zhangjie" => "454200568@qq.com" }
s.source       = { :git => "https://github.com/JekinChou/JKPhotoBrowser.git", :tag => "#{s.version}" }
s.platform = :ios,'8.0'
s.requires_arc = true
s.ios.deployment_target = '8.0'
s.source_files  = 'JKPhotoBrowserKit/**/*.{h,m}'
s.frameworks = "UIKit","Foundation","AssetsLibrary","Photos"
s.dependency  'YYImage', '~> 1.0.4'
s.dependency 'YYWebImage', '~> 1.0.5'
end

