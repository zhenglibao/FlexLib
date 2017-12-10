# FlexLib

[![CI Status](http://img.shields.io/travis/zhenglibao/FlexLib.svg?style=flat)](https://travis-ci.org/zhenglibao/FlexLib)
[![Version](https://img.shields.io/cocoapods/v/FlexLib.svg?style=flat)](http://cocoapods.org/pods/FlexLib)
[![License](https://img.shields.io/cocoapods/l/FlexLib.svg?style=flat)](http://cocoapods.org/pods/FlexLib)
[![Platform](https://img.shields.io/cocoapods/p/FlexLib.svg?style=flat)](http://cocoapods.org/pods/FlexLib)

## FlexLib

FlexLib is an obj-c layout framework for iOS. It's based on [yoga](https://facebook.github.io/yoga/) layout engine which implement  mostly compatible flexbox model.

With FlexLib, you can write iOS ui as fast as web or android, simple & fast & powerful.

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

### Use xml layout file for ViewController:

* Write layout with xml file. The following is a demo file:

![demo](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/res/viewcontroller.png){:height="100%" width="100%"}

This file is self-explained. This file will be used as table cell for UITableView.

* Derive view controller class from FlexBaseVC

![demo](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/res/viewcontroller_class.png){:height="100%" width="100%"}

![demo](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/res/viewcontroller_class2.png){:height="100%" width="100%"}

### Use xml layout file for TableCell:

* Write layout with xml file. There is no difference than view controller layout except that it will be used for tabel cell.

* Derive table cell class from FlexBaseTableCell:

![demo](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/res/tabelcell_class.png){:height="100%" width="100%"}

![demo](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/res/tabelcell_class2.png){:height="100%" width="100%"}

* In cellForRowAtIndexPath callback, call initWithFlex to build cell. In heightForRowAtIndexPath, call heightForWidth to calculate height

![demo](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/res/tabelcell_class3.png){:height="100%" width="100%"}


### Use xml layout file for other view:

* Write layout xml file.

* Use FlexRootView to load xml file, then set attribute to make it have flexible width or height

* add this FlexRootView as child view to other normal parent view

## Reference

 ![layout attributes](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/layout.pdf)
 
 ![view attributes](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/view.pdf)

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

zhenglibao, 798393829@qq.com.

You can contact me if you have any problem.

I hope you will like it. :)

## License

FlexLib is available under the MIT license. See the LICENSE file for more info.
