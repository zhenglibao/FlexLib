# FlexLib

[![CI Status](http://img.shields.io/travis/zhenglibao/FlexLib.svg?style=flat)](https://travis-ci.org/zhenglibao/FlexLib)
[![Version](https://img.shields.io/cocoapods/v/FlexLib.svg?style=flat)](http://cocoapods.org/pods/FlexLib)
[![License](https://img.shields.io/cocoapods/l/FlexLib.svg?style=flat)](http://cocoapods.org/pods/FlexLib)
[![Platform](https://img.shields.io/cocoapods/p/FlexLib.svg?style=flat)](http://cocoapods.org/pods/FlexLib)

## FlexLib
![english](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Readme.md)

FlexLib是用Obj-c语言编写的ios布局框架。 该框架基于[yoga](https://facebook.github.io/yoga/) 布局引擎，该引擎实现了一套flexbox布局模型，与flexbox大部分是兼容的。

使用FlexLib, 可以大幅提高ios的界面开发速度，能够与web和安卓相当，该框架使用简单同时能够应付复杂的布局。

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


## 例子

下载代码, 打开`Example/FlexLib.xcworkspace` 即可运行.

## 属性参考

布局属性已经稳定，但视图属性仍然在快速增加中。你可以通过在工程中搜索FLEXSET来找到所有支持的视图属性。如果现有的视图属性不能满足要求，你也可以扩展属于自己的视图属性，然后在xml文件中使用.

 ![layout attributes](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/layout.pdf)
 
 ![view attributes](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/view.pdf)
 

## 安装

通过pod方式安装FlexLib，例子如下:

```ruby
pod 'FlexLib'
```

## 接下来要增加的特性
* 更多的视图属性
* 布局热更新机制
* size class支持

## 作者

zhenglibao, 798393829@qq.com. QQ群: 687398178

欢迎咨询各种问题.

希望你能够喜欢这个项目. :)

### 关于Flexbox
[CSS-flexbox](https://css-tricks.com/snippets/css/a-guide-to-flexbox/)

[Yoga-flexbox](https://facebook.github.io/yoga/docs/flex-direction/)

## 版权

FlexLib is available under the MIT license. See the LICENSE file for more info.
