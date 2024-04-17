Pod::Spec.new do |spec|
	spec.name                  = "TWLSwiftKit"
	spec.version               = "1.0.0"
	spec.summary               = "Some quick functions for iOS."
	spec.homepage              = "https://github.com/LongerONE/TWLSwiftKit"
	spec.license               = "MIT"
	spec.author                = { "LongerONE" => "tangwanlong425@qq.com" }
	spec.platform              = :ios, "13.0"
	spec.source                = { :git => "https://github.com/LongerONE/TWLSwiftKit.git", :tag => "#{spec.version}" }
	spec.source_files          = "TWLSwiftKit/TWLSwiftKit/**/*.{swift}"
	spec.framework             = "UIKit"
	spec.framework             = "AVFoundation"
	spec.framework             = "Security"
end
