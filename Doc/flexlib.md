

之前写了两篇文章介绍FlexLib这个布局库，见[iOS新一代界面开发利器](https://juejin.im/post/5a367aaaf265da432652eaaf)和[是时候抛弃Masonry了](https://juejin.im/post/5a4468f3f265da432a7be16c)。很多网友都非常的感兴趣，也有一些网友表达了不同的观点，今天以一个实际的页面编写过程来介绍一下这个库究竟是如何提高iOS界面开发效率的。

## 最终的运行效果图

![运行效果图](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/res/flexdemo.gif)
该页面有几个特点：
* 中间的UITextView输入区域可以随着文字的输入动态调整高度，同时有一个最大的高度限制和一个最小的高度
* 下面的图片区域可以动态添加矩形方框，同时可以删除
* 当高度增大到超出一屏幕的时候，可以拖动页面进行滚动

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
        <FlexContainerView name="_imgParent" layout="flexWrap:wrap,flexDirection:row,justifyContent:flex-start">
            
            <FlexTouchView onPress="onAddImage" layout="width:20%,margin:2%,aspectRatio:1,justifyContent:center,alignItems:center" attr="borderRadius:10,borderWidth:1,borderColor:#e5e5e5,underlayColor:#e5e5e5">
                <UILabel attr="text:+,fontSize:20,color:#999999"/>
            </FlexTouchView>
        </FlexContainerView>
    </UIView>
</FlexScrollView>
```

FlexScrollView是FlexLib提供的核心类之一，该类能够自动计算子view的宽和高并设置contentSize，并且当子view隐藏或者改变宽、高时能够自动更新其contentSize，并且布局也会自动刷新。
FlexTextView是另外一个系统提供的类，能够自动根据输入的文字调整其高度，且保证其高度不会超出最小和最大高度。

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
    [self prepareInputs];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    [_imgParent insertSubview:cell atIndex:0];
    
    UILabel* label=[UILabel new];
    [label enableFlexLayout:YES];
    [label setViewAttrStrings:@[
                                @"fontSize",@"16",
                                @"color",@"red",
                                @"text",@"删除",
                                ]];
    [cell addSubview:label];
    
    [_imgParent markDirty];
}
@end

```

该实现与传统方式的区别在于，图片区域内容的管理不是通过UICollectionView，而是简单的通过添加、删除view来实现的，因此避免了大量的回调，只要线性的添加删除即可，添加完毕后调用markDirty界面布局即自动刷新。


读者可以自行比较传统方式布局与该框架在实现上的差异。
更多关于FlexLib的例子见这里：
[https://github.com/zhenglibao/FlexLib](https://github.com/zhenglibao/FlexLib)




