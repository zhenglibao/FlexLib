#
# Be sure to run `pod lib lint FlexLib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FlexLib'
  s.version          = '3.1.2'
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
  
  s.ios.deployment_target = '8.0'
  s.default_subspec = 'standard'
  
  s.subspec 'standard' do |ss|
    ss.source_files = 'FlexLib/Classes/**/*'
    ss.resource_bundles = {
       'FlexLib' => ['FlexLib/Assets/*']
    }
  
    ss.dependency 'Yoga', '1.14.0'
    ss.library = 'xml2', 'c++'
    ss.xcconfig = { 'HEADER_SEARCH_PATHS' => '/usr/include/libxml2' }
    #s.private_header_files = 'FlexLib/Classes/private/*.h'
    #s.public_header_files = 'FlexLib/Classes/*.h'
  
    non_arc_files   = 'FlexLib/Classes/GDataXMLNode.{h,m}'
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
