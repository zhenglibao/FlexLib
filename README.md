# FlexLib

[![CI Status](http://img.shields.io/travis/zhenglibao/FlexLib.svg?style=flat)](https://travis-ci.org/zhenglibao/FlexLib)
[![Version](https://img.shields.io/cocoapods/v/FlexLib.svg?style=flat)](http://cocoapods.org/pods/FlexLib)
[![License](https://img.shields.io/cocoapods/l/FlexLib.svg?style=flat)](http://cocoapods.org/pods/FlexLib)
[![Platform](https://img.shields.io/cocoapods/p/FlexLib.svg?style=flat)](http://cocoapods.org/pods/FlexLib)

## FlexLib

FlexLib is an obj-c layout framework for iOS. It's based on yoga layout engine which implement  mostly compatible flexbox model.

## Usage

### Write layout with xml file. The following is a demo file:
![demo](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/res/xmldemo.png)
This file is self-explained.

### Derive your view controller class from FlexBaseVC or table cell from FlexBaseTableCell.
Declare any variable in this class which will be binded by those controls with "name" attribute. "onPress" event will also be binded.
Then you can use your class.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

FlexLib is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'FlexLib'
```

## Author

zhenglibao, 798393829@qq.com

## License

FlexLib is available under the MIT license. See the LICENSE file for more info.
