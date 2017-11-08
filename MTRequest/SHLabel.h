//
//  SHLabel.h
//  MACAPP1
//
//  Created by HaoSun on 2017/11/6.
//  Copyright © 2017年 YHKIT. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <Cocoa/Cocoa.h>

typedef enum : NSUInteger
{
    ABAlignmentStyleLeft    = 1,
    ABAlignmentStyleRight   = 2,
    ABAlignmentStyleCenter  = 3
} ABAlignmentStyle;

typedef enum : NSUInteger
{
    ABTruncationStyleNone       = 1,
    ABTruncationStyleStart      = 2,
    ABTruncationStyleMiddle     = 3,
    ABTruncationStyleEnd        = 4
} ABTruncationStyle;

@interface SHLabel :NSView

//包含的文字
@property (nonatomic, copy) NSString *text;

//字体大小
@property (nonatomic, assign) CGFloat fontSize;

//字体名字
@property (nonatomic, copy) NSString *fontName;

//文字颜色
@property (nonatomic, strong) NSColor *textColor;

//文字清晰度，数值在0～2这个区间中，2最清晰
@property (nonatomic, assign) CGFloat definitionValue;

//文字对齐方式
@property (nonatomic, assign) ABAlignmentStyle alignmentStyle;

//文字过长时哪里省略
@property (nonatomic, assign) ABTruncationStyle truncationStyle;

//设置特定range的文字颜色
-(void)setTextColor:(NSColor *)textColor withRange:(NSRange)range;
@end
