//
//  FlexRootView.h
//  Pods
//
//  Created by zhenglibao on 2017/12/4.
//

#import <UIKit/UIKit.h>


@interface FlexRootView : UIView

@property(nonatomic,assign) BOOL flexibleWidth;
@property(nonatomic,assign) BOOL flexibleHeight;

+(FlexRootView*)loadWithNodeFile:(NSString*)resName
                           Owner:(NSObject*)owner;

-(CGSize)calculateSize;

-(CGSize)calculateSize:(CGSize)szLimit;

-(void)registSubView:(UIView*)subView;

@end
