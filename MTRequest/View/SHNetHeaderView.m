//
//  SHNetHeaderView.m
//  MACAPP1
//
//  Created by HaoSun on 2017/11/6.
//  Copyright © 2017年 YHKIT. All rights reserved.
//

#import "SHNetHeaderView.h"
#import "Masonry.h"

@interface SHNetHeaderView()

@end


@implementation SHNetHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupViews];
        [self setupLayouts];
    }
    return self;
}

- (void)setupViews {

    NSTextField *prefixLab = [[NSTextField alloc] init];
    prefixLab.placeholderString = @"ClassName:";
    _prefixLab = prefixLab;
    [self addSubview:_prefixLab];

    NSTextField *baseUrlLab = [[NSTextField alloc] init];
    baseUrlLab.placeholderString = @"BaseUrl";
    _baseUrlLab = baseUrlLab;
    [self addSubview:_baseUrlLab];

}


- (void)setupLayouts {
    CGFloat padding = 10.0f;
    [_prefixLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(padding);
        make.top.equalTo(self.mas_top).offset(padding);
        make.width.offset(100);
        make.height.offset(30);
    }];

    [_baseUrlLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(padding);
        make.top.equalTo(_prefixLab.mas_bottom).offset(padding);
        make.width.offset(100);
        make.height.offset(30);
    }];

}

@end
