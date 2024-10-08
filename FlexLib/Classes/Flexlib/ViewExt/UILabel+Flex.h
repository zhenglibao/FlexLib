/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */


#import <UIKit/UIKit.h>

@class FlexNode;

@interface UILabel (Flex)

-(NSMutableParagraphStyle*)paraStyle;

/*
 * 设置Attributed string，仅针对UILabel中包含子元素的情况下有效
 * 调用完后需要调用updateAttributeText方法来更新attributedText
 */
-(void)setFlexAttrString:(NSString*)text name:(NSString*)name;

/*
 * 设置attributed image，仅针对UILabel中包含子元素的情况下有效
 * 调用完后需要调用updateAttributeText方法来更新attributedText
 */
-(void)setFlexAttrImage:(NSString*)imageSource name:(NSString*)name;

-(void)setChildElems:(NSArray<FlexNode*>*)childElems;

-(FlexNode*)getFlexNode:(NSString*)childName;

-(void)updateAttributeText;

/**
 * 返回点对应的字符索引，pt为UILabel自身坐标系的点
 */
-(NSUInteger)charIndexAtPoint:(CGPoint)pt;

@end

