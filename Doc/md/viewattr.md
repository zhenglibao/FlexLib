# View attributes

**All subclass automatically own all the attributes of parent class.**

## There are six basic type attributes:
* string value:  the value can be one string. If the string contains comma, you should use \\, to prevent mess up, it also support \r(return) \n(newline) \t(table). '\\' will be '\'. Any other \c will be c.
* color value: the value can be color, the color be like #rrggbb or #aarrggbb, or the system predefined color: black/white/clear/darkGray/lightGray/gray/red/green/blue/cyan/yellow/magenta/orange/purple/brown
* number value: the value must be number
* number group value: the value should be like n1/n2/...
* boolean value: the value must be true or false
* enumeration value: the value should be one of the list
* @ is special attribute, the value should be filename/stylename. It can be used to reference style in other style file.

## UIView attributes:
* bgColor: color
* borderWidth: number
* borderColor: color
* borderRadius: number
* shadowOffset: number group (2)
* shadowRadius: number
* shadowColor: color
* contentMode: enumeration -- scaleToFill / scaleAspectFit / scaleAspectFill / redraw / center / top / bottom / left / right / topLeft / topRight / bottomLeft / bottomRight
* alpha: number
* tag: number
* hidden: boolean
* clipsToBounds: boolean
* tintColor: color
* stickTop: boolean

## FlexTouchView attributes:
* underlayColor: color
* activeOpacity: number (0~1)

## FlexScrollView attributes:
* horzScroll: boolean
* vertScroll: boolean

## UILabel attributes:
* text: string
* fontSize: number
* lineBreakMode: enumeration -- wordWrapping / charWrapping / clipping / truncatingHead / truncatingTail / truncatingMiddle
* linesNum: number
* color: color
* shadowColor: color
* highlightTextColor: color
* textAlign: enumeration -- left / center / right / justified / natural
* interactEnable: boolean
* adjustFontSize: boolean

## UIControl attributes:
* enabled: boolean
* selected: boolean
* highlighted: boolean
* vertAlignment: enumeration -- center / top / bottom / fill
* horzAlignment: enumeration -- center / left / right / fill / ( leading / trailing: only ios11)

## UIButton attributes:
* title: string
* color: color

## UIImageView attributes:
* source: string
* highlightSource: string
* interactEnable: boolean

## UIScrollView attributes:
* horzIndicator: boolean
* vertIndicator: boolean
* pageEnabled: boolean
* scrollEnabled: boolean
* bounces: boolean
* indicatorStyle: enumeration -- default / black /white

## UITextField attributes:
* text: string
* placeHolder: string
* fontSize: number
* color: color
* textAlign: enumeration -- left / center / right / justified /natural
* boderStyle: enumeration -- none / line / bezel /roundRect
* interactEnable: boolean
* adjustFontSize: boolean

## UITextView attributes:
* text: string
* fontSize: number
* color: color
* textAlign: enumeration -- left / center / right / justified /natural
* editable: boolean
* selectable: boolean

## UIActivityIndicatorView attributes:
* style: enumeration -- whiteLarge / white /gray
* color: color

## UIActivityIndicatorView attributes:
* style: enumeration -- whiteLarge / white /gray
* color: color

## UIDatePicker attributes:
* pickerMode: enumeration -- time / date / dateTime / countDownTimer

## UIPageControl attributes:
* numberOfPages: number
* currentPage: number
* hidesForSinglePage: boolean
* pageTintColor: color
* curPageTintColor: color

## UIPickerView attributes:
* showSelIndicator: boolean

## UIProgressView attributes:
* style: enumeration -- default / bar
* progress: number
* progressTintColor: color
* trackTintColor: color

## UISearchBar attributes:
* barStyle: enumeration -- default / black / opaque
* text: string
* prompt: string
* placeholder: string
* bookMarkBtn: boolean
* cancelBtn: boolean
* resultBtn: boolean
* resultBtnSelected: boolean

## UISegmentedControl attributes:
* selectedIndex: number
* tintColor: color


## UISlider attributes:
* value: number
* minValue: number
* maxValue: number
* continuous: boolean
* minTintColor: color
* maxTintColor: color
* thumbTintColor: color

## UIStepper attributes:
* value: number
* minValue: number
* maxValue: number
* stepValue: number
* continuous: boolean
* autorepeat: boolean
* wraps: boolean
* tintColor: color

## UISwitch attributes:
* tintColor: color
* onTintColor: color
* on: boolean

## UITabBar attributes:
* tintColor: color
* barTintColor: color
* unSelTintColor: color
* itemPosition: enumeration -- auto / fill / center
* itemSpacing: number
* itemWidth: number
* barStyle: enumeration -- default / black /opaque /translucent
* translucent: boolean

## UIToolbar attributes:
* barStyle: enumeration -- default / black /opaque /translucent
* translucent: boolean
* tintColor: color
* barTintColor: color






