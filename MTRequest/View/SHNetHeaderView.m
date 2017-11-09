//
//  SHNetHeaderView.m
//  MACAPP1
//
//  Created by HaoSun on 2017/11/6.
//  Copyright © 2017年 YHKIT. All rights reserved.
//

#import "SHNetHeaderView.h"
#import "Masonry.h"
#import "SHNetLabel.h"
@interface SHNetHeaderView()

@end


@implementation SHNetHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    CGFloat padding = SHNetLabelH *0.5;
    SHNetLabel *classNameLabel = [[SHNetLabel alloc] init];
    classNameLabel.frame = CGRectMake(0, 0, SHNetLabelW, SHNetLabelH);
    classNameLabel.title = @"className";
    _classNameLabel = classNameLabel;
    [self addSubview:_classNameLabel];

    SHNetLabel *progectLabel = [[SHNetLabel alloc] init];
    progectLabel.frame = CGRectMake(0, CGRectGetMaxY(_classNameLabel.frame)+padding, SHNetLabelW, SHNetLabelH);
    progectLabel.title = @"progectName";
    _progectLabel = progectLabel;
    [self addSubview:_progectLabel];

    SHNetLabel *authoLabel = [[SHNetLabel alloc] init];
    authoLabel.frame = CGRectMake(0, CGRectGetMaxY(_progectLabel.frame)+padding, SHNetLabelW, SHNetLabelH);
    authoLabel.title = @"authoName";
    _authoLabel = authoLabel;
    [self addSubview:_authoLabel];

    SHNetLabel *abLabel = [[SHNetLabel alloc] init];
    abLabel.frame = CGRectMake(0, CGRectGetMaxY(_authoLabel.frame)+padding, SHNetLabelW, SHNetLabelH);
    abLabel.title = @"前缀";
    _abLabel = abLabel;
    [self addSubview:_abLabel];
}


@end
