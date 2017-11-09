//
//  SHNetLabel.m
//  MACAPP1
//
//  Created by HaoSun on 2017/11/8.
//  Copyright © 2017年 YHKIT. All rights reserved.
//

#import "SHNetLabel.h"

@implementation SHNetLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {

    NSTextField *titleLab = [[NSTextField alloc] init];
    titleLab.enabled = NO;
    titleLab.frame = CGRectMake(0, 0, 80, SHNetLabelH);
    titleLab.textColor = [NSColor labelColor];
    titleLab.backgroundColor = [NSColor controlColor];
    _titleLab = titleLab;
    [self addSubview:_titleLab];

    NSTextField *contentLab = [[NSTextField alloc] init];
    contentLab.frame = CGRectMake(CGRectGetMaxX(_titleLab.frame), 0, 100, SHNetLabelH);
    _contentLab = contentLab;
    [self addSubview:_contentLab];
}

- (void)setTitle:(NSString *)title {

    _title = title;
    _titleLab.placeholderString = _title;
}

- (void)setContent:(NSString *)content {

    _content = content;
    _contentLab.stringValue = _content;
}

@end
