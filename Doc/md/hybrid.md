
## 在传统布局中使用嵌入xml布局

示例代码如下：
```objective-c
CGRect rcFrame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 0);
FlexFrameView* header = [[FlexFrameView alloc]initWithFlex:@"TableHeader" Frame:rcFrame Owner:self];
header.flexibleHeight = YES;
header.onFrameChange = ^(CGRect rc){
    [weakSelf tableHeaderFrameChange];
};
[header layoutIfNeeded];
_table.tableHeaderView = header;
```

FlexFrameView本身使用传统frame方式，在其内部维护一个使用flexbox方式布局的view，如果修改了xml中view的属性导致其大小发生变化，则需要通过onFrameChange来监听。

## 在xml中使用自定义的view，view的内部使用传统frame方式布局

这种情况无需特殊处理，直接在xml中像使用其他view一样使用即可。

需要注意的是，如果该view使用了特殊的初始化函数（不是init方式初始化），比如创建一个UITableView，需要调用其initWithFrame:style:方法，则需要在owner中（一般是ViewController)重载createView:Name:方法来创建该view。

