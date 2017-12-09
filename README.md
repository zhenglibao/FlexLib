# FlexLib

[![CI Status](http://img.shields.io/travis/zhenglibao/FlexLib.svg?style=flat)](https://travis-ci.org/zhenglibao/FlexLib)
[![Version](https://img.shields.io/cocoapods/v/FlexLib.svg?style=flat)](http://cocoapods.org/pods/FlexLib)
[![License](https://img.shields.io/cocoapods/l/FlexLib.svg?style=flat)](http://cocoapods.org/pods/FlexLib)
[![Platform](https://img.shields.io/cocoapods/p/FlexLib.svg?style=flat)](http://cocoapods.org/pods/FlexLib)

## FlexLib

FlexLib is an obj-c layout framework for iOS. It's based on [yoga](https://facebook.github.io/yoga/) layout engine which implement  mostly compatible flexbox model.

With FlexLib, you can write iOS as fast as web or android, simple & fast & powerful.

### Reference
[CSS-flexbox](https://css-tricks.com/snippets/css/a-guide-to-flexbox/)

[Yoga-flexbox](https://facebook.github.io/yoga/docs/flex-direction/)

## Feature
* layout based on xml format
* auto variable binding
* onPress event binding
* support layout attribute (padding/margin/width/...)
* support view attribute (eg: bgColor/fontSize/...)
* support reference predefined style
* view attributes extensible
* support modal view
* table cell height calculation
* support iPhoneX perfectly

## Example

To run the example project, clone the repo, and open `Example/FlexLib.xcworkspace` with XCode to run.

## Usage

### Write layout with xml file. The following is a demo file:

![demo](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/res/xmldemo.png)

This file is self-explained. This file will be used as table cell for UITableView.

### Derive your view controller class from FlexBaseVC or table cell from FlexBaseTableCell.
Declare any variable in this class which will be binded by those controls with "name" attribute. "onPress" event will also be binded.
Then you can use your class as normal.

The following is the effect for the last layout file.

![effect for vertical](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/res/effect-vert.png)

![effect for horzantal](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/res/effect-horz.png)

## Reference
 ![layout attributes](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/layoutattr.htm)
 ![view attributes](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/viewattr.htm)

## Installation

FlexLib is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'FlexLib'
```

## Todo
* more view attributes
* hot update layout
* size class support

## Author

zhenglibao, 798393829@qq.com

## License

FlexLib is available under the MIT license. See the LICENSE file for more info.
