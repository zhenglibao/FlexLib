#
# Be sure to run `pod lib lint FlexLib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FlexLib'
  s.version          = '4.0.0'
  s.summary          = 'An obj-c flex layout framework for IOS & mac'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
It's a layout framework based on yoga engine. The main purpose is to provide easy and fast usage.
                       DESC

  s.homepage         = 'https://github.com/zhenglibao/FlexLib'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '798393829@qq.com' => '798393829@qq.com' }
  s.source           = { :git => 'https://github.com/zhenglibao/FlexLib.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '11.0'
  s.default_subspec = 'standard'
  
  #Yoga最新版本1.19.0使用源码方式引入
  s.subspec 'yoga' do |ss|
    ss.source_files = 'FlexLib/Classes/yoga/**/*.{c,h,cpp}'
    ss.public_header_files = 'FlexLib/Classes/yoga/{Yoga,YGEnums,YGMacros,YGValue}.h'
    ss.requires_arc = false
    ss.pod_target_xcconfig = {
        'DEFINES_MODULE' => 'YES'
    }
    ss.compiler_flags = [
        '-fno-omit-frame-pointer',
        '-fexceptions',
        '-Wall',
        '-Werror',
        '-std=c++1y',
        '-fPIC'
    ]
  end
  
  s.subspec 'standard' do |ss|
    ss.source_files = 'FlexLib/Classes/{FlexLib,YogaKit}/**/*'
    ss.resource_bundles = {
       'FlexLib' => ['FlexLib/Assets/*']
    }
  
    ss.dependency 'FlexLib/yoga'
    ss.library = 'xml2', 'c++'
    ss.xcconfig = { 'HEADER_SEARCH_PATHS' => '/usr/include/libxml2' }
  
    non_arc_files   = 'FlexLib/Classes/Flexlib/GDataXMLNode.{h,m}'
    ss.exclude_files = non_arc_files
    ss.subspec 'no-arc' do |sna|
      sna.requires_arc = false
      sna.source_files = non_arc_files
    end  
  end

  s.subspec 'preview' do |ss|
    ss.source_files = 'FlexLibPreview/Classes/**/*'
    ss.resource_bundles = {
       'FlexLibPreview' => ['FlexLibPreview/Assets/*']
    }
  
    ss.dependency 'FlexLib/standard'
  end
end
