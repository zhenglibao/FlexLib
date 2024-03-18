/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */


#import "FlexLayout.h"
#import "UIView+Yoga.h"


@interface FlexLayout()
{
    YGLayout* _layout;
}
@end

@implementation FlexLayout

-(instancetype)initWithYGLayout:(YGLayout*)layout
{
    if(self = [super init])
    {
        _layout = layout;
    }
    return self;
}

- (FlexLayout *(^)(EmDirection))direction
{
    return ^(EmDirection value)
    {
        switch(value)
        {
            case dirInherit:
                self->_layout.direction = YGDirectionInherit;
                break;
            case dirLtr:
                self->_layout.direction = YGDirectionLTR;
                break;
            case dirRtl:
                self->_layout.direction = YGDirectionRTL;
                break;
            default:
                NSCAssert(NO, @"wrong direction value");
                break;
        }
        return self;
    };
}

- (FlexLayout *(^)(EmFlexDirection))flexDirection
{
    return ^(EmFlexDirection value)
    {
        switch(value)
        {
            case flexDirCol:
                self->_layout.flexDirection = YGFlexDirectionColumn;
                break;
            case flexDirColReverse:
                self->_layout.flexDirection = YGFlexDirectionColumnReverse;
                break;
            case flexDirRow:
                self->_layout.flexDirection = YGFlexDirectionRow;
                break;
            case flexDirRowReverse:
                self->_layout.flexDirection = YGFlexDirectionRowReverse;
                break;
            default:
                NSCAssert(NO, @"wrong flexDirection value");
                break;
        }
        return self;
    };
}

- (FlexLayout * _Nonnull (^)(EmJustify))justifyContent
{
    return ^(EmJustify value)
    {
        switch(value)
        {
            case justifyFlexStart:
                self->_layout.justifyContent = YGJustifyFlexStart;
                break;
            case justifyCenter:
                self->_layout.justifyContent = YGJustifyCenter;
                break;
            case justifyFlexEnd:
                self->_layout.justifyContent = YGJustifyFlexEnd;
                break;
            case justifySpaceBetween:
                self->_layout.justifyContent = YGJustifySpaceBetween;
                break;
            case justifySpaceAround:
                self->_layout.justifyContent = YGJustifySpaceAround;
                break;
            case justifySpaceEvenly:
                self->_layout.justifyContent = YGJustifySpaceEvenly;
                break;
            default:
                NSCAssert(NO, @"wrong justifyContent value");
                break;
        }
        return self;
    };
}

static YGAlign toYGAlign(EmAlign align)
{
    YGAlign r = YGAlignAuto;
    switch (align) {
        case alignAuto:
            r = YGAlignAuto;
            break;
        case alignFlexStart:
            r = YGAlignFlexStart;
            break;
        case alignCenter:
            r = YGAlignCenter;
            break;
        case alignFlexEnd:
            r = YGAlignFlexEnd;
            break;
        case alignStretch:
            r = YGAlignStretch;
            break;
        case alignBaseline:
            r = YGAlignBaseline;
            break;
        case alignSpaceBetween:
            r = YGAlignSpaceBetween;
            break;
        case alignSpaceAround:
            r = YGAlignSpaceAround;
            break;
        default:
            NSCAssert(NO, @"wrong align value");
            break;
    }
    return r;
}

- (FlexLayout * _Nonnull (^)(EmAlign))alignContent
{
    return ^(EmAlign value)
    {
        self->_layout.alignContent = toYGAlign(value);
        return self;
    };
}

- (FlexLayout * _Nonnull (^)(EmAlign))alignItems
{
    return ^(EmAlign value)
    {
        self->_layout.alignItems = toYGAlign(value);
        return self;
    };
}

- (FlexLayout * _Nonnull (^)(EmAlign))alignSelf
{
    return ^(EmAlign value)
    {
        self->_layout.alignSelf = toYGAlign(value);
        return self;
    };
}


- (FlexLayout * _Nonnull (^)(EmPositionType))position
{
    return ^(EmPositionType value)
    {
        switch(value)
        {
            case posStatic:
                self->_layout.position = YGPositionTypeStatic;
                break;
            case posRelative:
                self->_layout.position = YGPositionTypeRelative;
                break;
            case posAbsolute:
                self->_layout.position = YGPositionTypeAbsolute;
                break;
            default:
                NSCAssert(NO, @"wrong position value");
                break;
        }
        return self;
    };
}

- (FlexLayout * _Nonnull (^)(EmFlexWrap))flexWrap
{
    return ^(EmFlexWrap value)
    {
        switch(value)
        {
            case flexNoWrap:
                self->_layout.flexWrap = YGWrapNoWrap;
                break;
            case flexWrap:
                self->_layout.flexWrap = YGWrapWrap;
                break;
            case flexWrapReverse:
                self->_layout.flexWrap = YGWrapWrapReverse;
                break;
            default:
                NSCAssert(NO, @"wrong flexWrap value");
                break;
        }
        return self;
    };
}

- (FlexLayout * _Nonnull (^)(EmOverflow))overflow
{
    return ^(EmOverflow value)
    {
        switch(value)
        {
            case overflowVisible:
                self->_layout.overflow = YGOverflowVisible;
                break;
            case overflowHidden:
                self->_layout.overflow = YGOverflowHidden;
                break;
            case overflowScroll:
                self->_layout.overflow = YGOverflowScroll;
                break;
            default:
                NSCAssert(NO, @"wrong overflow value");
                break;
        }
        return self;
    };
}

- (FlexLayout * _Nonnull (^)(EmDisplay))display
{
    return ^(EmDisplay value)
    {
        switch(value)
        {
            case displayFlex:
                self->_layout.display = YGDisplayFlex;
                break;
            case displayNone:
                self->_layout.display = YGDisplayNone;
                break;
            default:
                NSCAssert(NO, @"wrong overflow value");
                break;
        }
        return self;
    };
}

#define FLEX_FLOAT_ATTR_IMPL(attrName)   \
- (FlexLayout *(^)(float))attrName      \
{                                       \
    return ^(float value)               \
    {                                   \
        self->_layout.attrName = value; \
        return self;                    \
    };                                  \
}

#define FLEX_NUM_ATTR_IMPL(attrName)    \
- (FlexLayout *(^)(float))attrName      \
{                                       \
    return ^(float value)               \
    {                                   \
        self->_layout.attrName = (YGValue) { .value = value, .unit = YGUnitPoint };\
        return self;                    \
    };                                  \
}

#define FLEX_PERCENT_ATTR_IMPL(attrName)    \
- (FlexLayout *(^)(float))attrName##Percent \
{                                       \
    return ^(float value)               \
    {                                   \
        self->_layout.attrName = (YGValue) { .value = value, .unit = YGUnitPercent };\
        return self;                    \
    };                                  \
}

#define FLEX_NONE_ATTR_IMPL(attrName)    \
- (FlexLayout *(^)(void))attrName##None  \
{                                       \
    return ^(void)                      \
    {                                   \
        self->_layout.attrName = (YGValue) { .value = NAN, .unit = YGUnitUndefined };\
        return self;                    \
    };                                  \
}

#define FLEX_AUTO_ATTR_IMPL(attrName)    \
- (FlexLayout *(^)(void))attrName##Auto  \
{                                       \
    return ^(void)                      \
    {                                   \
        self->_layout.attrName = (YGValue) { .value = NAN, .unit = YGUnitAuto };\
        return self;                    \
    };                                  \
}

#define FLEX_VALUE_ATTR_IMPL(attrName)  \
FLEX_NUM_ATTR_IMPL(attrName)            \
FLEX_PERCENT_ATTR_IMPL(attrName)        \
FLEX_NONE_ATTR_IMPL(attrName)


#define FLEX_AUTO_VALUE_ATTR_IMPL(attrName)  \
FLEX_NUM_ATTR_IMPL(attrName)            \
FLEX_PERCENT_ATTR_IMPL(attrName)        \
FLEX_AUTO_ATTR_IMPL(attrName)


FLEX_FLOAT_ATTR_IMPL(flex)
FLEX_FLOAT_ATTR_IMPL(flexGrow)
FLEX_FLOAT_ATTR_IMPL(flexShrink)
FLEX_FLOAT_ATTR_IMPL(aspectRatio)

FLEX_AUTO_VALUE_ATTR_IMPL(flexBasis)
FLEX_AUTO_VALUE_ATTR_IMPL(width)
FLEX_AUTO_VALUE_ATTR_IMPL(height)

FLEX_VALUE_ATTR_IMPL(minWidth)
FLEX_VALUE_ATTR_IMPL(minHeight)
FLEX_VALUE_ATTR_IMPL(maxWidth)
FLEX_VALUE_ATTR_IMPL(maxHeight)
FLEX_VALUE_ATTR_IMPL(left)
FLEX_VALUE_ATTR_IMPL(top)
FLEX_VALUE_ATTR_IMPL(right)
FLEX_VALUE_ATTR_IMPL(bottom)
FLEX_VALUE_ATTR_IMPL(start)
FLEX_VALUE_ATTR_IMPL(end)
FLEX_VALUE_ATTR_IMPL(margin)
FLEX_VALUE_ATTR_IMPL(marginLeft)
FLEX_VALUE_ATTR_IMPL(marginTop)
FLEX_VALUE_ATTR_IMPL(marginRight)
FLEX_VALUE_ATTR_IMPL(marginBottom)
FLEX_VALUE_ATTR_IMPL(marginStart)
FLEX_VALUE_ATTR_IMPL(marginEnd)
FLEX_VALUE_ATTR_IMPL(marginHorizontal)
FLEX_VALUE_ATTR_IMPL(marginVertical)
FLEX_VALUE_ATTR_IMPL(paddingLeft)
FLEX_VALUE_ATTR_IMPL(paddingTop)
FLEX_VALUE_ATTR_IMPL(paddingRight)
FLEX_VALUE_ATTR_IMPL(paddingBottom)
FLEX_VALUE_ATTR_IMPL(paddingStart)
FLEX_VALUE_ATTR_IMPL(paddingEnd)
FLEX_VALUE_ATTR_IMPL(paddingHorizontal)
FLEX_VALUE_ATTR_IMPL(paddingVertical)
FLEX_VALUE_ATTR_IMPL(padding)

@end

