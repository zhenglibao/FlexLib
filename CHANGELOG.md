# 版本变更日志
**FlexLib**的所有版本的变更日志都将会在这里记录.

---
## 3.1.2
1.FlexCollectionCell和FlexBaseTableCell对iOS15的适配

## 3.1.1
1.增加编译为flex布局时对热更新的支持

## 3.1.0
1.FlexRootView增加禁止布局功能

## 3.0.0
1.增加自定义宏支持
2.支持在xml中使用数学表达式，表达式中支持使用自定义宏
3.改进iPhone X判断

## 2.9.0
1.支持加载二进制布局功能
2.

## 2.8.0
1.增加样式功能，支持class标签
2.修复FlexTextView用initWithFrame方法创建时会闪退问题
3.其他问题修复

## 2.7.0
1.解决AppStore审核期间苹果认为包含的热更新问题，将debug模式下的预览等功能拆分为独立的FlexLib/preview组件
2.增加Flexlib/osx支持mac版的布局

## 2.6.0
1.性能优化后的稳定版本
2.增加FlexTableHeaderFooterView组件
3.修复在新XCode下的获取window问题

## 2.5.0 (该版本有兼容性问题，请直接使用2.6.0版本)
1. 对hidden属性变化时的优化
2. 优化各个组件的性能，减少FlexFrameView, FlexCustomBaseView的视图层级
3. 移除FlexScrollView对吸顶效果的支持

## 2.4.0
1.布局文件和风格支持后缀
2.支持颜色映射

## 2.3.6
1.优化在线加载资源，在加载失败情况下自动使用本地资源

## 2.3.5
1.优化缓存目录

## 2.3.4
1. 优化键盘弹起事件监听
2. 优化FlexTextView文本改变事件

## 2.3.3
1. 规范FlexCollectionCell的rootView属性命名


## 2.3.2
1. 优化查看布局
2. 适配iOS13，移除placeholder的kvo

## 2.3.1
1. flex实现使用yoga原生方式
2. justifyContent增加space-evenly布局方式

## 2.3.0
1. 更新yoga到1.14.0版本，yoga修复了一些bug以及兼容性问题

## 2.2.2
修复FlexXmlBaseView的bug

## 2.2.1
1. UILabel的富文本支持国际化
2. FlexXmlBaseView增加代码创建方式

## 2.2.0
1. 增加FlexXmlBaseView，该类用来制作组件，与FlexCustomBaseView类似，不同的是FlexXmlBaseView的派生类只能用在xml中，好处是减少视图层级

## 2.1.2
1. 修复UILabel中不存在text属性时却动态修改导致不生效的问题
2. 修复布局过程中再次调用hidden或者text属性导致KVO异常的问题

## 2.1.0
1. UILabel全面支持富文本，可以在XML中直接给UILabel添加子元素，包括Text属性和Image属性，且子元素支持设置点击事件
2. 更完善的getSafeArea实现，全面支持手机和pad的横竖屏设置

## 2.0.1
1. 替换FlexNode.h和FlexUtils.h的头文件引用，之前可能导致某些版本的ide报错

## 2.0.0
1. 增加bundleForRes接口，bundleForImage默认使用bundleForRes的返回值，此方法能够更好地支持在组件中使用xml布局
2. 增加flexBasis属性
3. iOS11以下添加状态栏高度
4. owner增加可重载方法needBindVariable, 允许owner不声明变量而使用名称动态获取视图
5. FlexCustomBaseView用在非xml布局时允许根据内容更新自身的frame
6. FlexCustomBaseView和FlexCustomView支持使用评估高度


## 1.9.4
1. 修复FlexModalView连续快速隐藏/显示切换的时候导致不显示的问题

## 1.9.3
1. 对于margin, padding等Layout类型的值（支持数值和百分比），可以通过设置为none或auto取消原来设置的值
2. margin和padding支持一次设置4个不同的值，格式为  左/上/右/下
3. FlexBaseTableCell增加rootView属性
4. UIScrollView增加alwaysBounceVertical和alwaysBounceHorizontal属性

## 1.9.2
1. 增加FlexCollectionCell
2. FlexBaseTableCell支持通过registerClass方式创建

## 1.9.1
1. 升级检测iPhone X设备方法
2. 升级getSafeArea方法实现，兼容性更好

## 1.9.0
1. FlexBaseTableCell支持评估高度，增加onInit方法可以重写。

## 1.8.7
1. 重写FlexHttpViewerVC::setValue:forKey:和FlexViewer::setValue:forKey:防止查看xml布局时有内存泄漏
2. FlexRootView的KVO策略调整，只观测UILabel的text和attributeText属性

## 1.8.6
修复监听UITextField导致的泄漏

## 1.8.5
修复FlexModalView的循环引用问题

## 1.8.4
修复UILabel扩展可能导致的潜在内存泄漏, 增加错误处理显示机制

## 1.8.3
修复以下问题：
FlexTextView的placeholder在重设frame后没有刷新的问题

## 1.8.2
批量增加以下属性：
UIView::font，格式为   字体名称|字体大小    字体名称也可以是bold或者italic
FlexTextView::placeholder
FlexTextView::placeholderColor
UILabel::lineSpacing
UILabel::paragraphSpacing
UILabel::firstLineHeadIndent
UILabel::headIndent
UILabel::tailIndent


## 1.8.1
1. FlexFrameView增加对safeArea的支持，能够更好的用在ViewController上（也就是FlexFrameView可以不再和子FlexRootView的大小保持一致），使用时直接设置FlexRootView的safeArea属性即可。
2. 修复FlexContainerView在所有子view均隐藏时返回大小不正确的问题

## 1.7.4
1. 修复FlexCustomBaseView中initWithFrame的问题

## 1.7.3
1. 增加owner自定义加载布局接口

## 1.7.2
1. avoidiPhoneXBottom属性向前兼容

## 1.7.1
1. 增加avoidiPhoneXBottom属性
2. 热刷新支持绝对路径

## 1.7.0
1.支持在后台线程调用计算布局大小
2.增加对自定义创建xml子节点的支持

## 1.6.5
增加输入相关属性

## 1.6.4
1. 增加布局事件通知FLEXDIDLAYOUT
## 1.6.3
1. 修复text属性监听问题

## 1.6.2
1. 增加目录索引功能，极大的方便了预览设置

## 1.6.0
1.增加在线布局浏览器功能，可以在线通过http浏览本地布局文件

## 1.5.0
1. 增加FlexCollectionView，解决UICollectionView无法直接在xml中使用的问题
2. 增加枚举组属性支持
3. 创建视图初始化增加容错机制
4. 增加大量视图属性
5. 修复在有导航栏且导航栏不透明时导致rootView位置不对的问题
6. 自定义缩放接口增加属性名称
7. 修复text属性监听问题

## 1.4.0
1. 增加接口控制xml中view的初始化和完成后事件
2. 增加FlexTouchView的触摸事件

## 1.3.2
1. 布局属性增加缩放支持

## 1.3.1
1. 增加缩放因子，可以根据屏幕不同给字体等设置相应的缩放比例

## 1.3.0
1. 增加FlexCustomBaseView，支持创建基于xml布局的自定义view

## 1.2.1
1. 增加FlexContainerView，用于在通过程序控制布局时作为动态添加、删除子view时使用
2. 修复YogaKit在某些情况下视图与yoga节点不一致的问题

## 1.2.0
1. 增加FlexFrameView，方便在不是ViewController和UITableCell的地方使用xml布局方案

### 1.1.1
1. 修复FlexScrollView在键盘弹出时子窗口大小不对的问题

## 1.1.0
1. 颜色值可以使用图片
2. 图片可以从owner指定的bundle读取

## 1.0.0
1. 增加多语言支持

## 0.9.1
1. 增加批量查看布局功能

## 0.9.0
1. 增加预览设置功能
2. 优化其他接口

## 0.8.2
1. Swift版本兼容测试通过
2. SafeArea的状态栏接口调整
3. 其他bug修复

## 0.8.1
1. 键盘多次弹出事件优化
2. 增加根据名字查找view接口


## 0.8.0
1. 增加布局文件缓存机制加快release模式下读取速度
2. 增加style文件缓存机制

## 0.7.6
1. 增加键盘工具栏来切换输入框
2. 修复iPhone X上躲避键盘后safearea不对的问题
3. 完美解决UITextView光标遮挡问题~
4. 多次键盘事件合并为一次处理
5. 其他代码及接口优化

## 0.7.0
1. ViewController增加躲避键盘区域功能
2. 增加FlexTextView自动更新大小功能
3. UIView增加扩展方法
4. FlexBaseTableCell增加onContentSizeChanged通知
5. 其他bug修复


## 0.6.5
1. 修复热更新问题
2. 修复某些情况下导航栏高度获取问题


## 0.6.2
1. 修复FlexTouchView高亮效果在轻触模式下不显示问题

## 0.6.1
1. 增加更丰富的热更新接口

## 0.6.0
1. 热更新支持

## 0.5.2
1. 修复ios11以下版本UIScrollView的contentInset问题

## 0.5.1
1. 增加FlexTouchMaskView来支持高亮效果

## 0.5.0
1. 增加FlexTouchView
2. 修复Yogakit里边measure导致的误差问题
3. 增加滚动吸顶效果

## 0.4.1
1. 增加FlexRootView的事件通知
2. 增加宏定义方便属性扩展
 
## 0.4.0
1. xml布局文件增加转义字符支持
2. 增加大量控件属性

## 0.3.2
1. 修复旋转问题
2. iphoneX高度适配

## 0.3.1
1. 修复tablecell不刷新问题
2. FlexModelView增加动画支持
3. 增加safeArea概念，优化LayoutSubViews

## 0.2.0
1. 增加FlexScrollView来支持滚动视图
2. 增加更多属性

## 之前版本
1. 完成初始版本
 
