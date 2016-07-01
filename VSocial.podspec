
Pod::Spec.new do |s|

  s.name         = "VSocial"
  s.version      = "1.0.3"
  s.summary      = "this is a social component, including the login and share of WeChat,weibo,qq"

  s.description  = <<-DESC
                   * It is a social component. 
                   * it can help you quickly integrate login and share function.
                   DESC
  s.homepage     = "https://github.com/lhjzzu/VSocial"
  s.license      = "MIT"
  s.author             = { "lhjzzu" => "1822657131@qq.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/lhjzzu/VSocial.git", :tag => s.version }
  s.requires_arc = true
  s.xcconfig = {'OTHER_LDFLAGS' => '-lObjC','ENABLE_BITCODE' => 'NO'}
  s.default_subspecs = 'Core','QQSDK', 'WBSDK', 'WXSDK'
  
  s.subspec 'Core' do |core|
    core.source_files = 'sdk/*.{h,m}'
    core.public_header_files = 'sdk/*.h'
    core.ios.vendored_frameworks = 'sdk/VNetworkManager.framework'
    core.resource = 'sdk/VSocialResources.bundle'
    core.frameworks = 'UIKit','Foundation', 'CoreGraphics','CoreText','QuartzCore','CoreTelephony','SystemConfiguration','CFNetwork','ImageIO','MobileCoreServices','Security'
    core.libraries = 'c++', 'z','sqlite3.0'
  end

  s.subspec 'QQSDK' do |qq|
    qq.source_files = 'sdk/Channels/QQSDK/*.{h,m}'
    qq.ios.vendored_frameworks = 'sdk/Channels/QQSDK/TencentOpenAPI.framework'
    qq.resource = 'sdk/Channels/QQSDK/TencentOpenApi_IOS_Bundle.bundle'
    qq.dependency 'VSocial/Core'
  end

  s.subspec 'WBSDK' do |wb|
    wb.source_files = 'sdk/Channels/WBSDK/*.{h,m}'
    wb.vendored_libraries = 'sdk/Channels/WBSDK/libSinaWeiboSDK.a'
    wb.resource = 'sdk/Channels/WBSDK/WeiboSDK.bundle'
    wb.dependency 'VSocial/Core'
  end

  s.subspec 'WXSDK' do |wx|
    wx.source_files = 'sdk/Channels/WXSDK/*.{h,m}'
    wx.vendored_libraries = 'sdk/Channels/WXSDK/libWeChatSDK.a'
    wx.dependency 'VSocial/Core'
  end


end
