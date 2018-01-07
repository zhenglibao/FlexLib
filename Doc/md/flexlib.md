使用FlexLib提高iOS界面开发效率

## 前言

之前写了两篇文章介绍FlexLib这个布局库，见[iOS新一代界面开发利器](https://juejin.im/post/5a367aaaf265da432652eaaf)和[是时候抛弃Masonry了](https://juejin.im/post/5a4468f3f265da432a7be16c)。很多网友非常的感兴趣，也有一些网友质疑该框架是否真的能提高效率。毕竟真用到项目中的话要学习很多新东西，如果不能提高效率无疑会浪费大量时间。

今天就以一个实际的页面编写过程来介绍一下这个库究竟是如何提高iOS界面开发效率的。

## 最终的运行效果图

![运行效果图](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/res/flexdemo.gif)

该页面内容很少，但有如下几个特点：
* 中间的TextView输入区域可以随着文字的输入动态调整高度，同时有一个最大的高度限制和一个最小的高度限制
* 下面的图片区域可以动态添加矩形方框，同时可以删除
* 当高度增大到超出一屏幕的时候，可以拖动页面进行滚动
* 当进行输入时，可以通过键盘上的工具栏来切换输入焦点，如果输入框不在屏幕范围内，能够自动滚动让其处于显示范围内

上述这些特点也是很多项目中非常常见的，读者可以想象一下自己实现这些功能需要多少行代码😀

## 布局文件的编写

```xml
<?xml version="1.0" encoding="utf-8"?>

<FlexScrollView name="scroll"  layout="flex:1" attr="bgColor:white,vertScroll:true,vertIndicator:true">
    <UIView layout="flexDirection:row,alignItems:center,margin:10">
        <UIView layout="flex:1">
            <UILabel attr="fontSize:16,color:#333333,text:归属合同"/>
            <UIView layout="height:10"/>
            <UITextField layout="width:100%" attr="placeHolder:请输入本次收款金额,fontSize:16,color:#333333"/>
        </UIView>
        <UIImageView layout="height:20,width:20" attr="source:arrow_right.png"/>
    </UIView>
    
    <UIView layout="height:1" attr="bgColor:#e5e5e5"/>
    
    <UIView layout="flexDirection:row,alignItems:center,margin:10">
        <UIView layout="flex:1">
            <UILabel attr="fontSize:16,color:#333333,text:备注"/>
            <UIView layout="height:10"/>
            <FlexTextView layout="width:100%,minHeight:30,maxHeight:95" attr="fontSize:16,color:#333333,text:这是一个UITextView\,你可以输入多行文本来试试效果:)"/>
        </UIView>
    </UIView>
    
    <UIView layout="height:10" attr="bgColor:#e5e5e5"/>
    
    <UIView layout="margin:10">
        <UILabel attr="fontSize:16,color:#333333,text:图片"/>
        <UIView layout="height:10"/>
        <FlexContainerView name="_imgParent" layout="flexWrap:wrap,flexDirection:row,">           
            <FlexTouchView onPress="onAddImage" layout="width:20%,margin:2%,aspectRatio:1,justifyContent:center,alignItems:center" attr="borderRadius:10,borderWidth:1,borderColor:#e5e5e5,underlayColor:#e5e5e5">
                <UILabel attr="text:+,fontSize:20,color:#999999"/>
            </FlexTouchView>
        </FlexContainerView>
    </UIView>
</FlexScrollView>
```

FlexScrollView是FlexLib提供的核心类之一，该类能够自动计算子view的宽和高并设置contentSize，并且当子view隐藏或者改变宽、高时能够自动更新其contentSize，并且布局也会自动刷新。

FlexTextView是另外一个系统提供的类，能够自动根据输入的文字调整其高度，且保证其高度不会超出最小和最大高度。

为了便于理解，没有把属性放在独立的样式文件中，导致看起来略显凌乱。在实际的项目中，推荐将样式放到独立的样式文件中，这样程序中多个页面可以重复利用样式而不需要重新设置。


### 代码实现

```objective-c

// TextViewVC.h
@interface TextViewVC : FlexBaseVC
@end

// TextViewVC.m
#import "TextViewVC.h"

@interface TextViewVC ()
{
    UIScrollView* scroll;
    UIView* _imgParent;
}

@end

@implementation TextViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"TextView Demo";
    [self prepareInputs];   //这一行能够自动增加键盘工具栏，帮助切换输入框
}

-(void)removeCell:(UIGestureRecognizer*)sender
{
    UIView* cell = sender.view;
    [cell removeFromSuperview];
    [_imgParent markDirty]; 
}
-(void)onAddImage
{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeCell:)];
    
    UIView* cell = [[UIView alloc]init];
    [cell enableFlexLayout:YES];
    [cell addGestureRecognizer:tap];
    [cell setLayoutAttrStrings:@[
                                 @"width",@"20%",
                                 @"aspectRatio",@"1",
                                 @"margin",@"2%",
                                 @"alignItems",@"center",
                                 @"justifyContent",@"center",
                                 ]];
    [cell setViewAttr:@"bgColor" Value:@"#e5e5e5"];
    [cell setViewAttr:@"borderRadius" Value:@"10"];

    UILabel* label=[UILabel new];
    [label enableFlexLayout:YES];
    [label setViewAttrStrings:@[
                                @"fontSize",@"16",
                                @"color",@"red",
                                @"text",@"删除",
                                ]];
    [cell addSubview:label];

    [_imgParent insertSubview:cell atIndex:0];
    [_imgParent markDirty];
}
@end

```

该实现与传统方式的区别在于，图片区域内容的管理不是通过UICollectionView或者UITableView来进行的，而是简单的通过添加、删除view来实现，因此避免了需要写大量的回调方法，只要线性的添加删除即可，添加完毕后调用markDirty界面布局即自动刷新。

读者可以自行比较传统方式布局与使用该框架在实现上的差异。

对于一些复杂页面，比如tableview的cell中嵌套tableview这种类型的页面更能够发挥该框架的优势，因为里面的高度更新、计算全都是自动完成的。


### 关于布局文件的智能提示

之前很多网友抱怨编辑布局文件时没有智能提示，其实现代的ide基本上都可以通过配置让其支持智能提示。这里推荐使用VSCode编辑器，可以按照[这里](https://github.com/zhenglibao/FlexLib/wiki/Visual-Studio-Code%E6%99%BA%E8%83%BD%E6%8F%90%E7%A4%BA)的步骤设置其智能提示。编辑时智能提示的效果如图：

![智能提示](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/res/intellisense.gif)

### 该框架能和Autolayout、Frame方式混用吗？

当然可以，可以一部分页面使用Autolayout，另外一部分页面使用xml。甚至在同一个页面也可以一部分控件使用frame方式布局，另外一部分控件使用xml方式。具体使用方式可以参考[这里](https://github.com/zhenglibao/FlexLib/wiki/%E5%9C%A8%E4%B8%80%E4%B8%AA%E9%A1%B5%E9%9D%A2%E4%B8%AD%E6%B7%B7%E5%90%88%E4%BD%BF%E7%94%A8%E4%BC%A0%E7%BB%9Fframe%E5%B8%83%E5%B1%80%E5%92%8Cflex%E5%B8%83%E5%B1%80)


根据在作者自己项目中的经验，使用该框架对于复杂页面最多能够节省近80%的开发时间，一般的页面也能够节省近一半的时间，当然前提是对[flexbox](https://juejin.im/post/5a33a6926fb9a045104a8d3c)模型较为熟悉。关于flexbox，作者想说的是这是一个跨平台的东西，安卓、web、react native、Texture等都支持，如果不想以后一直局限在iOS平台上的话，学习了解一下还是有必要的😀。

对这个库感兴趣的读者可以在这里了解更多的信息：
[https://github.com/zhenglibao/FlexLib](https://github.com/zhenglibao/FlexLib)




