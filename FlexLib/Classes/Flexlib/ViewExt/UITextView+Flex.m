/**
 * Copyright (c) 2017-present, zhenglibao, Inc.
 * email: 798393829@qq.com
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */


#import "UITextView+Flex.h"
#import "UIView+Flex.h"
#import <objc/runtime.h>
#import "../FlexUtils.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"


static NameValue _align[] =
{
    {"left", NSTextAlignmentLeft},
    {"center", NSTextAlignmentCenter},
    {"right", NSTextAlignmentRight},
    {"justified", NSTextAlignmentJustified},
    {"natural", NSTextAlignmentNatural},
};

static NameValue _gKeyboardType[] =
{
    {"default", UIKeyboardTypeDefault},
    {"asciiCapable", UIKeyboardTypeASCIICapable},
    {"numberAndPunct", UIKeyboardTypeNumbersAndPunctuation},
    {"url", UIKeyboardTypeURL},
    {"numberPad", UIKeyboardTypeNumberPad},
    {"phonePad", UIKeyboardTypePhonePad},
    {"namePhonePad", UIKeyboardTypeNamePhonePad},
    {"emailAddress", UIKeyboardTypeEmailAddress},
    {"decimalPad", UIKeyboardTypeDecimalPad},
    {"twitter", UIKeyboardTypeTwitter},
    {"webSearch", UIKeyboardTypeWebSearch},
    {"asciiCapableNumberPad", UIKeyboardTypeASCIICapableNumberPad},
};

static NameValue _gAutocaptializationType[] =
{
    {"none", UITextAutocapitalizationTypeNone},
    {"words", UITextAutocapitalizationTypeWords},
    {"sentences", UITextAutocapitalizationTypeSentences},
    {"allCharacters", UITextAutocapitalizationTypeAllCharacters},
};

static NameValue _gAutocorrectionType[] =
{
    {"default", UITextAutocorrectionTypeDefault},
    {"no", UITextAutocorrectionTypeNo},
    {"yes", UITextAutocorrectionTypeYes},
};

static NameValue _gSpellCheckType[] =
{
    {"default", UITextSpellCheckingTypeDefault},
    {"no", UITextSpellCheckingTypeNo},
    {"yes", UITextSpellCheckingTypeYes},
};

static NameValue _gKeyboardAppearance[] =
{
    {"default", UIKeyboardAppearanceDefault},
    {"dark", UIKeyboardAppearanceDark},
    {"light", UIKeyboardAppearanceLight},
    {"alert", UIKeyboardAppearanceAlert},
};

static NameValue _gReturnKeyType[] =
{
    {"default", UIReturnKeyDefault},
    {"go", UIReturnKeyGo},
    {"google", UIReturnKeyGoogle},
    {"join", UIReturnKeyJoin},
    {"next", UIReturnKeyNext},
    {"route", UIReturnKeyRoute},
    {"search", UIReturnKeySearch},
    {"send", UIReturnKeySend},
    {"yahoo", UIReturnKeyYahoo},
    {"done", UIReturnKeyDone},
    {"emergencyCall", UIReturnKeyEmergencyCall},
    {"continue", UIReturnKeyContinue},
};

@implementation UITextView (Flex)

FLEXSET(text)
{
    self.text = sValue ;
}
FLEXSET(fontSize)
{
    float nSize = [sValue floatValue];
    if(nSize > 0){
        UIFont* font = [UIFont systemFontOfSize:nSize];
        self.font = font;
    }
}
FLEXSET(color)
{
    UIColor* clr = colorFromString(sValue,owner);
    if(clr!=nil){
        self.textColor = clr ;
    }
}

FLEXSET(textAlign)
{
    self.textAlignment = (NSTextAlignment)NSString2Int(sValue, _align, sizeof(_align)/sizeof(NameValue));
}

FLEXSET(editable)
{
    self.editable = String2BOOL(sValue);
}
FLEXSET(selectable)
{
    self.selectable = String2BOOL(sValue);
}

FLEXSETENUM(autocapitalizationType, _gAutocaptializationType)
FLEXSETENUM(autocorrectionType, _gAutocorrectionType)
FLEXSETENUM(spellCheckingType, _gSpellCheckType)
FLEXSETBOOL(secureTextEntry)
FLEXSETENUM(keyboardType, _gKeyboardType)
FLEXSETENUM(keyboardAppearance, _gKeyboardAppearance)
FLEXSETENUM(returnKeyType, _gReturnKeyType)
FLEXSETBOOL(enablesReturnKeyAutomatically)

FLEXSET(value)
{
    self.text = sValue;
}

@end

#pragma clang diagnostic pop
