//
//  UILabel.h
//  FlexViewer
//
//  Created by 郑立宝 on 2019/11/19.
//  Copyright © 2019 郑立宝. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel : NSTextField

@property(nonatomic,assign) NSTextAlignment textAlignment;
@property(nonatomic,assign) NSInteger numberOfLines;
@property(nonatomic,strong) NSString* text;
@property(nonatomic,strong) NSAttributedString* attributedText;

@end

NS_ASSUME_NONNULL_END
