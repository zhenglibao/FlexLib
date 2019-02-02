//
//  FlexXmlBaseView.h
//  Expecta
//
//  Created by 郑立宝 on 2019/2/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 * 用来制作基于xml的组件的基类，该类与FlexCustomBaseView的区别是：
 * FlexCustomBaseView的派生类既可以用在xml中，也可以像传统的UIView派生类
 * 那样使用initWithFrame创建，缺点是会额外的增加多余的视图层级
 * FlexXmlBaseView仅能使用在xml文件中，不能使用代码方式(通过init或者initWithFrame)创建，也
 * 不能直接设置frame，优点是更加轻量级，不会增加额外的视图层级
 */

@interface FlexXmlBaseView : UIView

/// 子类可以重写这个方法来做额外的初始化工作
-(void)onInit;

@end

NS_ASSUME_NONNULL_END
