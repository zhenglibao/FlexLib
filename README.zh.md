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
* 视图属性支持扩展
* 支持模态显示视图
* 表格cell高度动态计算
* 完美适配iPhone X
* 支持运行时更新界面
* 支持自动调整view的区域来躲避键盘
* 支持键盘工具栏来切换输入框

---

## 使用方法

### 将xml布局文件用于视图控制器:

* 编写xml布局文件，下面是一个样例:

```xml
<UIView layout="flex:1,justifyContent:center,alignItems:center" attr="bgColor:lightGray">
    <UIView layout="height:1,width:100%" attr="bgColor:red"/>
    <FlexScrollView name="_scroll" layout="flex:1,width:100%,alignItems:center" attr="vertScroll:true">
        <UILabel name="_label" attr="@:system/buttonText,text:You can run on iPhoneX,color:blue"/>
        <UIView onPress="onTest:" layout="@:system/button" attr="bgColor:#e5e5e5">
            <UILabel attr="@:system/buttonText,text:Test ViewController"/>
        </UIView>
        <UIView onPress="onTestTable:" layout="@:system/button" attr="bgColor:#e5e5e5">
            <UILabel attr="@:system/buttonText,text:Test TableView"/>
        </UIView>
        <UIView onPress="onTestScrollView:" layout="@:system/button" attr="bgColor:#e5e5e5">
            <UILabel attr="@:system/buttonText,text:Test ScrollView"/>
        </UIView>
        <UIView onPress="onTestModalView:" layout="@:system/button" attr="bgColor:#e5e5e5">
            <UILabel attr="@:system/buttonText,text:Test ModalView"/>
        </UIView>
        <UIView onPress="onTestLoginView:" layout="@:system/button" attr="bgColor:#e5e5e5">
            <UILabel attr="@:system/buttonText,text:Login Example"/>
        </UIView>
    </FlexScrollView>
</UIView>
```

* 从FlexBaseVC派生自定义的视图控制器

```objective-c

@interface FlexViewController : FlexBaseVC
@end

```

```objective-c

@interface FlexViewController ()
{
    // these will be binded to those control with same name in xml file
    FlexScrollView* _scroll;
    UILabel* _label;
}
@end

@implementation FlexViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"FlexLib Demo";
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)onTest:(id)sender {
    TestVC* vc=[[TestVC alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)onTestTable:(id)sender {
    TestTableVC* vc=[[TestTableVC alloc]init];
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
@end

```

```objective-c

@interface TestTableCell()
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

* 使用FlexRootView加载xml文件, 设置对应属性是其高度或者宽度可变

* 将FlexRootView添加到其他未使用flexbox进行布局的普通视图上。

---

## 运行时编辑预览界面

### 编辑预览视图控制器界面

* 在工作目录开启http服务器：

如果mac系统安装的是python2.7，可以在命令行通过如下命令开启：python -m SimpleHTTPServer 8000

* 在程序初始化的地方设置访问本机http服务器的基地址:

    FlexSetPreviewBaseUrl(@"http://你本机的ip:端口号/FlexLib/res/");

* 运行程序，打开要调试的视图控制器，在模拟器中按下Cmd+R来刷新界面. 注意：该快捷键仅在debug模式下可用.

**注意：Cmd+R是在模拟器中当试图控制器处于显示状态时按下的，不是在xcode里边。baseurl是用来拼接资源的url用的。比如你设置的是'http://ip:port/abc/',而你需要访问TestVC，则最终的url将是'http://ip:port/abc/TestVC.xml'**

### 编辑预览任意界面

* 按照前面方法开启http服务器并设置http基地址

* 设置资源加载方式
    FlexSetLoadFunc(YES) or
    FlexSetCustomLoadFunc(loadfunc)
这样程序运行后所有界面将通过http进行加载，如果网络速度慢可能会导致界面卡顿

---

## 例子

下载代码, 打开`Example/FlexLib.xcworkspace` 即可运行.

---

## 属性参考

布局属性已经稳定，但视图属性仍然在快速增加中。你可以通过在工程中搜索FLEXSET来找到所有支持的视图属性。如果现有的视图属性不能满足要求，你也可以扩展属于自己的视图属性，然后在xml文件中使用.

 [layout attributes](https://github.com/zhenglibao/FlexLib/blob/master/Doc/layout.md)
 
 [view attributes](https://github.com/zhenglibao/FlexLib/blob/master/Doc/viewattr.md)
 
 ---

## 安装

通过pod方式安装FlexLib，例子如下:

```ruby
pod 'FlexLib'
```

---

## 关于Flexbox
[CSS-flexbox](https://css-tricks.com/snippets/css/a-guide-to-flexbox/)

[Yoga-flexbox](https://facebook.github.io/yoga/docs/flex-direction/)

---

## 作者

zhenglibao, 798393829@qq.com. QQ群: 687398178

欢迎咨询各种问题.

希望你能够喜欢这个项目. :)

---

## 版权

FlexLib is available under the MIT license. See the LICENSE file for more info.

---

