//
//  FlexXmlBaseView.h
//  Expecta
//
//  Created by 郑立宝 on 2019/2/2.
//

#import <UIKit/UIKit.h>

@class FlexRootView;

NS_ASSUME_NONNULL_BEGIN

/*
 * 用来制作基于xml的组件的基类，该类与FlexCustomBaseView的区别是：
 * FlexCustomBaseView的派生类既可以用在xml中，也可以像传统的UIView派生类
 * 那样使用initWithFrame创建，缺点是会额外的增加多余的视图层级
 * FlexXmlBaseView能使用在xml文件中,可以通过initWithRootView方式创建，但不能通过
 * initWithFrame创建，也不能能直接设置frame，优点是更加轻量级，不会增加额外的视图层级
 */

@interface FlexXmlBaseView : UIView

/// 用代码的方式创建视图组件
-(instancetype)initWithRootView:(FlexRootView*)rootview;

/// 子类可以重写这个方法来做额外的初始化工作
-(void)onInit;

@end

NS_ASSUME_NONNULL_END
