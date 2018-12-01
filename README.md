# FlexLib

[![CI Status](http://img.shields.io/travis/zhenglibao/FlexLib.svg?style=flat)](https://travis-ci.org/zhenglibao/FlexLib)
[![Version](https://img.shields.io/cocoapods/v/FlexLib.svg?style=flat)](http://cocoapods.org/pods/FlexLib)
[![License](https://img.shields.io/cocoapods/l/FlexLib.svg?style=flat)](http://cocoapods.org/pods/FlexLib)
[![Platform](https://img.shields.io/cocoapods/p/FlexLib.svg?style=flat)](http://cocoapods.org/pods/FlexLib)

## FlexLib
[中文版](https://github.com/zhenglibao/FlexLib/blob/master/README.zh.md)

FlexLib is an Objective-C layout framework for iOS. It's based on [flexbox](https://css-tricks.com/snippets/css/a-guide-to-flexbox/) model which is standard for web layout. So the layout capability is powerful and easy to use.

With FlexLib, you can write iOS UI much faster than before, and there are better adaptability.

- [Screenshots](#screenshots)
- [Feature](#feature)
- [Advantage](#advantage)
- [Usage](#usage)
- [Hot Preview](#hot-preview)
- [Usage For Swift Project](#usage-for-swift-project)
- [Example](#example)
- [Attribute Reference](#attribute-reference)
- [FlexLib Classes](#flexlib-classes)
- [Installation](#installation)
- [Intellisense](#intellisense)
- [FAQ](#faq)
- [About Flexbox](#about-flexbox)
- [Author](#author)
- [License](#license)

---

## Screenshots

This demo is hot preview:

![example0](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/hotpreview2.gif)

Can you imagine you almost need nothing code to implement the following effect?

![example1](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/scrollview.gif)
![example2](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/modelview.gif)

Avoid keyboard automatically

![example3](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/textview.gif)

iPhone X adaption

![iPhoneX](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/tableview.gif)


---

## Feature
* layout based on xml format
* auto variable binding
* onPress event binding
* support layout attribute (padding/margin/width/...)
* support view attribute (eg: bgColor/fontSize/...)
* support reference predefined style
* view attributes extensible
* UILabel fully support rich-text
* support modal view
* table cell height calculation
* support iPhoneX perfectly
* support hot preview
* auto adjust view to avoid keyboard
* keyboard toolbar to switch input field
* cache support for release mode
* support Swift project
* view all layouts in one page (Control+V)
* multi-language support

---

## Advantage

* The speed of flexbox is much faster than autolayout. 

![compare result](https://user-gold-cdn.xitu.io/2017/12/25/1608d27446d5177d?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

* Flexbox is more general than autolayout. Flexbox is standard for web and it's also used in ReactNative, Weex, AsyncDisplayKit, Android, ...

* FlexLib has better readability. View the autolayout written by others is really boring.

* For page like the following image, you don't need UITableView any more. Just write everything in one xml. It's much simpler and maintainable.

![setting page](https://github.com/zhenglibao/FlexLib/raw/master/Doc/res/setting.png)

* The calculation for height of complex UITableViewCell is really boring. With FlexLib, all the calculation is automatically.

* FlexScrollView (the subclass of UIScrollView) can manage its contentSize automatically. I'm sure it will save you a lot of time.

* To show or hide subview, just set hidden property. All the layout will refresh automatically.

* Hot preview is magic. You can see the final effect on device without restart the app.

* UILabel support rich-text and onPress for every rich-text part, and it also allow to change rich-text dynamically.

---

## Usage

### Use xml layout file for ViewController:

* Write layout with xml file.

The following is a demo file:

```xml
<?xml version="1.0" encoding="utf-8"?>

<UIView layout="flex:1,justifyContent:center,alignItems:center" attr="bgColor:white">
<UIView name="_test" onPress="onPressTest:" layout="width:40,height:40" attr="bgColor:lightGray"/>
</UIView>
```

* Derive view controller class from FlexBaseVC

```objective-c

@interface FlexViewController : FlexBaseVC
{
    // these will be binded to those control with same name in xml file
    UIView* _test;
}
@end

@implementation FlexViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"FlexLib Demo";
}
// This function will bind to onPress event
- (void)onPressTest:(id)sender {
    TestVC* vc=[[TestVC alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}
@end

```
* Now you can use the controller as normal:
```objective-c

    FlexViewController *vc = [[FlexViewController alloc] init];

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;

    [self.window makeKeyAndVisible];

```

### Use xml layout file for TableCell:

* Write layout with xml file. There is no difference than view controller layout except that it will be used for tabel cell.

* Derive table cell class from FlexBaseTableCell:

```objective-c

@interface TestTableCell : FlexBaseTableCell
{
    UILabel* _name;
    UILabel* _model;
    UILabel* _sn;
    UILabel* _updatedBy;

    UIImageView* _return;
}
@end
@implementation TestTableCell
@end

```

* In cellForRowAtIndexPath callback, call initWithFlex to build cell. In heightForRowAtIndexPath, call heightForWidth to calculate height

```objective-c

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    static NSString *identifier = @"TestTableCellIdentifier";
    TestTableCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[TestTableCell alloc]initWithFlex:nil reuseIdentifier:identifier];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_cell==nil){
        _cell = [[TestTableCell alloc]initWithFlex:nil reuseIdentifier:nil];
    }
    return [_cell heightForWidth:_table.frame.size.width];
}

```

### Use xml layout file for other view:

* Write layout xml file.

* Use FlexFrameView to load xml file, you can set frame or make it flexible. After initiation, maybe you need to call layoutIfNeeded before add it to other view.

* add this FlexFrameView  to other traditional view

```objective-c

    //load TableHeader.xml as UITableView header
    
    CGRect rcFrame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 0);
    FlexFrameView* header = [[FlexFrameView alloc]initWithFlex:@"TableHeader" Frame:rcFrame Owner:self];
    header.flexibleHeight = YES;
    [header layoutIfNeeded];
    
    _table.tableHeaderView = header;
```

---

## Hot preview
You can see it [here](https://github.com/zhenglibao/FlexLib/wiki/Hot-preview)

---
## Usage For Swift Project
* Adjust 'Podfile' to use frameworks

![podfile](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/res/podfile.png)

* Extend your swift class from FlexBaseVC, FlexBaseTableCell, etc
* For those variables, onPress events, class, you should declare them with @objc keyword. Like this:

![@objc](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/res/atobjc.png)


---

## Example

To run the example project, clone the repo, and open `Example/FlexLib.xcworkspace` with XCode to run.

---

## Attribute Reference


FlexLib support two kinds of attribute: layout attribute and view attribute. Layout attribute conform with yoga implementation. View attribute can be extensible using FLEXSET macro.


**Notice: FlexLib will output log when it doesn't recognize the attribute you provided. So you should not ignore the log when you develop your project.**

 [layout attributes](https://github.com/zhenglibao/FlexLib/wiki/Layout-Attributes)
 
 [view attributes](https://github.com/zhenglibao/FlexLib/wiki/View-Attributes)
 
---

## FlexLib Classes
You can get it on [Wiki-FlexLib Classes](https://github.com/zhenglibao/FlexLib/wiki/FlexLib-Classes)

---

## Installation

FlexLib is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby

pod 'FlexLib'
```

---
## Intellisense
You can get it on [Wiki-VSCode Intellisense](https://github.com/zhenglibao/FlexLib/wiki/Visual-Studio-Code%E6%99%BA%E8%83%BD%E6%8F%90%E7%A4%BA)

---

## FAQ
You can get it on [Wiki-FAQ](https://github.com/zhenglibao/FlexLib/wiki/FAQ)

---

## About Flexbox
[CSS-flexbox](https://css-tricks.com/snippets/css/a-guide-to-flexbox/)

[Yoga-flexbox](https://facebook.github.io/yoga/docs/flex-direction/)

---

## Author

zhenglibao, 798393829@qq.com. QQ Group: 687398178

If you have problem, you can:

* reading the [wiki](https://github.com/zhenglibao/FlexLib/wiki)
* submit an issue [here](https://github.com/zhenglibao/FlexLib/issues)
* join the QQ Group to ask question or email to me

I hope you will like it. :)

---

## License

FlexLib is available under the MIT license. See the LICENSE file for more info.

---

