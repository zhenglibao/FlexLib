//
//  FlexBaseVC.h
//  Expecta
//
//  Created by zhenglibao on 2017/12/4.
//

#import <UIKit/UIKit.h>

@interface FlexBaseVC : UIViewController

// call this to provide flex res name
-(instancetype)initWithFlexName:(NSString*)flexName;

// override this to provide flex res name
-(NSString*)getFlexName;

// get root flex view
-(UIView*)rootView;

@end
