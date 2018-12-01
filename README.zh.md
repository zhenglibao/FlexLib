# FlexLib

[![CI Status](http://img.shields.io/travis/zhenglibao/FlexLib.svg?style=flat)](https://travis-ci.org/zhenglibao/FlexLib)
[![Version](https://img.shields.io/cocoapods/v/FlexLib.svg?style=flat)](http://cocoapods.org/pods/FlexLib)
[![License](https://img.shields.io/cocoapods/l/FlexLib.svg?style=flat)](http://cocoapods.org/pods/FlexLib)
[![Platform](https://img.shields.io/cocoapods/p/FlexLib.svg?style=flat)](http://cocoapods.org/pods/FlexLib)

## FlexLib
[english](https://github.com/zhenglibao/FlexLib/blob/master/README.md)

FlexLib是用Obj-c语言编写的ios布局框架。 该布局框架基于flexbox模型，这个模型是web端的布局标准。基于flexbox模型，FlexLib提供了强大的布局能力，并且易于使用。

使用FlexLib, 可以大幅提高ios的界面开发速度，并且适应性更好。

---

## 屏幕截图

运行时动态更新界面:

![example0](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/hotpreview2.gif)

样例截图

![example1](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/scrollview.gif)
![example2](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/modelview.gif)

自动躲避键盘遮挡

![example3](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/textview.gif)

iPhoneX adaption

![iPhoneX](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/tableview.gif)

---

## 特性
* 基于xml格式的布局文件
* 控件与变量自动绑定
* 默认支持onPress事件
* 支持大量的布局属性 (padding/margin/width/...)
* 支持视图属性 (eg: bgColor/fontSize/...)
* 支持引用预定义的风格
* UILabel支持在xml中设置富文本格式
* 视图属性支持扩展
* 支持模态显示视图
* 表格cell高度动态计算
* 完美适配iPhone X
* 支持运行时更新界面
* 支持自动调整view的区域来躲避键盘
* 支持键盘工具栏来切换输入框
* release模式下支持使用缓存机制加快速度
* 内置支持批量查看程序中所有布局功能(Control+V)

---

## FlexLib的优势

* 与Autolayout相比，Flexbox的布局速度要快的多，下图是各种布局的性能对比 

![compare result](https://user-gold-cdn.xitu.io/2017/12/25/1608d27446d5177d?imageView2/0/w/1280/h/960/format/webp/ignore-error/1)

* Flexbox更加通用，flexbox本身是web的布局标准，同时很多知名的开发库也都在使用Flexbox布局，比如ReactNative, Weex, AsyncDisplayKit, Android等

* FlexLib采用xml来书写布局，可读性更好

* 对于像下图这样的页面，无需再使用UITableView来实现，只需要在一个xml里边即可完成所有的界面效果，更加简单并且可维护性更好.

![setting page](https://github.com/zhenglibao/FlexLib/raw/master/Doc/res/setting.png)

* 对于复杂的UITableViewCell布局，计算cell的高度是件复杂的事情。使用FlexLib的话，所有的计算都可以自动完成

* FlexScrollView( UIScrollView的子类)可以自动管理滚动范围

* 显示或者隐藏子视图的话，只需要设置hidden属性即可，布局可以自动刷新

* 支持热刷新，无需重新启动app便可以看到修改后的界面效果

* UILabel支持直接在xml中设置富文本内容并支持点击事件，并允许运行时可以通过代码动态更新富文本内容

---

## 使用方法

### 将xml布局文件用于视图控制器:

* 编写xml布局文件，下面是一个样例:

```xml
<?xml version="1.0" encoding="utf-8"?>

<UIView layout="flex:1,justifyContent:center,alignItems:center" attr="bgColor:white">
<UIView name="_test" onPress="onPressTest:" layout="width:40,height:40" attr="bgColor:lightGray"/>
</UIView>
```

* 从FlexBaseVC派生自定义的视图控制器

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
// event binding
- (void)onPressTest:(id)sender {
    TestVC* vc=[[TestVC alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}
@end

```
* 像通常一样使用派生的试图控制器:
```objective-c

    FlexViewController *vc = [[FlexViewController alloc] init];

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;

    [self.window makeKeyAndVisible];

```

### 将xml布局用于TableCell:

* 编写xml布局文件，该布局文件与视图控制器使用的布局文件没有区别。

* 从FlexBaseTableCell派生子类:

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

* 在UITableView的回调函数cellForRowAtIndexPath中调用initWithFlex创建cell. 在 heightForRowAtIndexPath中调用heightForWidth计算cell的高度。

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

### 将xml布局用于普通视图:

* 编写xml布局文件

* 使用FlexFrameView加载xml文件, 设置其frame或者将其设置为高度或者宽度可变，在加入到其他view之前可能需要调用layoutIfNeeded

* 将FlexFrameView添加到其他未使用flexbox进行布局的普通视图上。

```objective-c

    //加载TableHeader.xml作为UITableView的header

    CGRect rcFrame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 0);
    FlexFrameView* header = [[FlexFrameView alloc]initWithFlex:@"TableHeader" Frame:rcFrame Owner:self];
    header.flexibleHeight = YES;
    [header layoutIfNeeded];

    _table.tableHeaderView = header;
```

---

## 运行时编辑预览界面
您可以在[这里](https://github.com/zhenglibao/FlexLib/wiki/Hot-preview)获取关于热预览的信息

---
## 在Swift工程中使用
* 将Podfile文件调整为使用framework方式，如下
![podfile](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/res/podfile.png)

* 从FlexBaseVC, FlexBaseTableCell派生自己的类

* 对于需要进行事件绑定的变量、事件、和类名，需要使用@objc关键字声明，使其能够在obj-c中访问, 如下：

![@objc](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/res/atobjc.png)

---

## 例子

下载代码, 打开`Example/FlexLib.xcworkspace` 即可运行.

---

## 属性参考

FlexLib支持两种类型的属性：布局属性和视图属性，布局属性与yoga所支持的属性一致，视图属性除了文档中所列的属性以外，还可以使用FLEXSET宏对现有属性进行扩展。

**注意：当FlexLib检测到任何不支持的属性时，将会在log窗口输出对应的日志，因此当你在开发项目时不要忽视他所输出的信息。**

[layout attributes](https://github.com/zhenglibao/FlexLib/wiki/Layout-Attributes)

[view attributes](https://github.com/zhenglibao/FlexLib/wiki/View-Attributes)
 
 ---

## 安装

通过pod方式安装FlexLib，例子如下:

```ruby
pod 'FlexLib'
```

---
## 智能提示
智能提示能够极大的提高开发效率，不过现代的IDE基本上都支持自定义配置。这里推荐使用VSCode，更多信息见这里:
[VSCode智能提示](https://github.com/zhenglibao/FlexLib/wiki/Visual-Studio-Code%E6%99%BA%E8%83%BD%E6%8F%90%E7%A4%BA)

---

## 问题解答
可以到这个[页面](https://github.com/zhenglibao/FlexLib/wiki/FAQ)查看问题解答

---

## 关于Flexbox
[CSS-flexbox](https://css-tricks.com/snippets/css/a-guide-to-flexbox/)

[Yoga-flexbox](https://facebook.github.io/yoga/docs/flex-direction/)

---

## 作者

zhenglibao, 798393829@qq.com. QQ群: 687398178

如果碰到问题，您可以：

* 阅读 [Wiki](https://github.com/zhenglibao/FlexLib/wiki)
* 在[这里](https://github.com/zhenglibao/FlexLib/issues)发起一个问题
* 加入QQ群咨询或者给我发邮件

希望你能够喜欢这个项目. :)

---

## 版权

FlexLib is available under the MIT license. See the LICENSE file for more info.

---

