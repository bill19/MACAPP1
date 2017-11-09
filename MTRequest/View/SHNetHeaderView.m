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

    SHNetLabel *classNameLabel = [[SHNetLabel alloc] init];
    classNameLabel.frame = CGRectMake(0, 0, SHNetLabelW, SHNetLabelH);
    classNameLabel.title = @"className";
    _classNameLabel = classNameLabel;
    [self addSubview:_classNameLabel];

    SHNetLabel *progectLabel = [[SHNetLabel alloc] init];
    progectLabel.frame = CGRectMake(0, CGRectGetMaxY(_classNameLabel.frame)+SHNetLabelH, SHNetLabelW, SHNetLabelH);
    progectLabel.title = @"progectName";
    _progectLabel = progectLabel;
    [self addSubview:_progectLabel];

    SHNetLabel *authoLabel = [[SHNetLabel alloc] init];
    authoLabel.frame = CGRectMake(0, CGRectGetMaxY(_progectLabel.frame)+SHNetLabelH, SHNetLabelW, SHNetLabelH);
    authoLabel.title = @"authoName";
    _authoLabel = authoLabel;
    [self addSubview:_authoLabel];

}


@end
