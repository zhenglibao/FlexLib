/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */


#import <Foundation/Foundation.h>

@class YGLayout;
@class FlexLayout;

typedef FlexLayout*_Nonnull(^FlexNumAttr)(float);       //数值类型
typedef FlexLayout*_Nonnull(^FlexPercentAttr)(float);   //百分比类型
typedef FlexLayout*_Nonnull(^FlexNoneAttr)(void);       //None类型
typedef FlexLayout*_Nonnull(^FlexAutoAttr)(void);       //Auto类型


#define FLEX_AUTO_VALUE_PROPERTY(attr)          \
@property(readonly) FlexNumAttr attr;           \
@property(readonly) FlexPercentAttr attr##Percent;\
@property(readonly) FlexAutoAttr attr##Auto;

#define FLEX_VALUE_PROPERTY(attr)               \
@property(readonly) FlexNumAttr attr;           \
@property(readonly) FlexPercentAttr attr##Percent;\
@property(readonly) FlexNoneAttr attr##None;


typedef enum : int
{
    dirInherit = 0,
    dirLtr,
    dirRtl,
}EmDirection;

typedef enum : int
{
    flexDirCol = 0,
    flexDirColReverse,
    flexDirRow,
    flexDirRowReverse,
}EmFlexDirection;

typedef enum : int
{
    justifyFlexStart = 0,
    justifyCenter,
    justifyFlexEnd,
    justifySpaceBetween,
    justifySpaceAround,
    justifySpaceEvenly,
}EmJustify;

typedef enum : int
{
    alignAuto = 0,
    alignFlexStart,
    alignCenter,
    alignFlexEnd,
    alignStretch,
    alignBaseline,
    alignSpaceBetween,
    alignSpaceAround,
}EmAlign;

typedef enum : int
{
    posStatic = 0,
    posRelative,
    posAbsolute,
}EmPositionType;


typedef enum : int
{
    flexNoWrap = 0,
    flexWrap,
    flexWrapReverse,
}EmFlexWrap;

typedef enum : int
{
    overflowVisible = 0,
    overflowHidden,
    overflowScroll,
}EmOverflow;

typedef enum : int
{
    displayFlex = 0,
    displayNone,
}EmDisplay;


NS_ASSUME_NONNULL_BEGIN

/**
 * 增加通过链式调用设置布局属性,如
 * view.flexLayout.top(10).minWidth(20).bottom.(-30)
 */

@interface FlexLayout : NSObject

@property(readonly) FlexLayout* (^direction)(EmDirection);
@property(readonly) FlexLayout* (^flexDirection)(EmFlexDirection);
@property(readonly) FlexLayout* (^justifyContent)(EmJustify);
@property(readonly) FlexLayout* (^alignContent)(EmAlign);
@property(readonly) FlexLayout* (^alignItems)(EmAlign);
@property(readonly) FlexLayout* (^alignSelf)(EmAlign);
@property(readonly) FlexLayout* (^position)(EmPositionType);
@property(readonly) FlexLayout* (^flexWrap)(EmFlexWrap);
@property(readonly) FlexLayout* (^overflow)(EmOverflow);
@property(readonly) FlexLayout* (^display)(EmDisplay);

@property(readonly) FlexNumAttr flex;
@property(readonly) FlexNumAttr flexGrow;
@property(readonly) FlexNumAttr flexShrink;
@property(readonly) FlexNumAttr aspectRatio;

/**
 * 定义数值属性、百分比属性、Auto属性
 */
FLEX_AUTO_VALUE_PROPERTY(flexBasis)
FLEX_AUTO_VALUE_PROPERTY(width)
FLEX_AUTO_VALUE_PROPERTY(height)


/**
 * 定义数值属性、百分比属性、None属性
 */
FLEX_VALUE_PROPERTY(minWidth)
FLEX_VALUE_PROPERTY(minHeight)
FLEX_VALUE_PROPERTY(maxWidth)
FLEX_VALUE_PROPERTY(maxHeight)
FLEX_VALUE_PROPERTY(left)
FLEX_VALUE_PROPERTY(top)
FLEX_VALUE_PROPERTY(right)
FLEX_VALUE_PROPERTY(bottom)
FLEX_VALUE_PROPERTY(start)
FLEX_VALUE_PROPERTY(end)
FLEX_VALUE_PROPERTY(margin)
FLEX_VALUE_PROPERTY(marginLeft)
FLEX_VALUE_PROPERTY(marginTop)
FLEX_VALUE_PROPERTY(marginRight)
FLEX_VALUE_PROPERTY(marginBottom)
FLEX_VALUE_PROPERTY(marginStart)
FLEX_VALUE_PROPERTY(marginEnd)
FLEX_VALUE_PROPERTY(marginHorizontal)
FLEX_VALUE_PROPERTY(marginVertical)
FLEX_VALUE_PROPERTY(paddingLeft)
FLEX_VALUE_PROPERTY(paddingTop)
FLEX_VALUE_PROPERTY(paddingRight)
FLEX_VALUE_PROPERTY(paddingBottom)
FLEX_VALUE_PROPERTY(paddingStart)
FLEX_VALUE_PROPERTY(paddingEnd)
FLEX_VALUE_PROPERTY(paddingHorizontal)
FLEX_VALUE_PROPERTY(paddingVertical)
FLEX_VALUE_PROPERTY(padding)


-(instancetype)initWithYGLayout:(YGLayout*)layout;

@end

NS_ASSUME_NONNULL_END
