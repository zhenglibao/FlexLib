//
//  FlexParentView.h
//  Expecta
//
//  Created by zhenglibao on 2017/12/8.
//

#import <UIKit/UIKit.h>

typedef void (^FrameChanged)(CGRect);

@interface FlexParentView : UIView

@property(nonatomic,copy) FrameChanged onFrameChange;

@end
