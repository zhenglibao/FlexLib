//
//  FlexRootView.h
//  Pods
//
//  Created by zhenglibao on 2017/12/4.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, FlexDirection) {
    FlexibleWidth = 1 << 0,  //宽度可扩展
    FlexibleHeight = 1 << 1, //高度可扩展
};

@interface FlexRootView : UIView

@property(nonatomic,assign) NSInteger flexOption;

+(FlexRootView*)loadWithNodeFile:(NSString*)resName
                           Owner:(NSObject*)owner;

-(CGSize)calculateSize;

-(CGSize)calculateSize:(CGSize)szLimit;

-(void)registSubView:(UIView*)subView;

@end
