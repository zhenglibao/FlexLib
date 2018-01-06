
首先写一个最简单的布局文件，如下:

```xml
<?xml version="1.0" encoding="utf-8"?>

<UIView onPress="onClose"
        layout="flex:1,margin:50,justifyContent:center"
        attr="borderColor:darkGray,borderWidth:1,bgColor:white">
        <UILabel name="" layout="alignSelf:center" attr="fontSize:14,color:#333333,linesNum:0,text:关闭"/>
</UIView>
```

屏幕截图如下:

[运行效果](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/res/archishot.png)

视图树：

[视图树](https://raw.githubusercontent.com/zhenglibao/FlexLib/master/Doc/res/viewtree.png)

从上面两张图可以看出，xml中最外面的view并不是ViewController的view，在外层还有2个附加的view：
* FlexRootView: 这是任何xml布局文件的view的根节点，负责对布局文件中的所有子view进行布局
* ControllerView: 这是视图控制器自身的view，其背景色自动匹配xml中最外层view的背景色

假设在逻辑像素为414x736大小的屏幕上，各个view的大小关系如下：

ControllerView应该是一个全屏幕的view，大小为414x736
FlexRootView的大小为 (414-safeArea.left-safeaArea.right)x(736-safeArea.top-safeArea.bottom)，其中safeArea是视图控制器中getSafeArea返回的值

默认情况下FlexBaseVC::getSafeArea会根据屏幕方向、是否带有导航栏等返回对应的safeArea的值。如果想要调整默认的FlexRootView的区域，可以重写getSafeArea方法。

另外在带有导航栏的视图控制器中，有时会由于其他属性（如navibar.translucent,automaticallyAdjustsScrollViewInsets等熟悉）会修改控制器的view的frame变成非全屏状态，此时也需要重写getSafeArea方法，来调整FlexRootView所占据的区域。



