//
//  SHChildNodeView.m
//  MACAPP1
//
//  Created by HaoSun on 2017/11/6.
//  Copyright © 2017年 YHKIT. All rights reserved.
//

#import "SHChildNodeView.h"
#import "Masonry.h"
@interface SHChildNodeView()

@end
@implementation SHChildNodeView

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

    NSTextField *childNodeLab = [[NSTextField alloc] init];
    childNodeLab.placeholderString = @"请输入url内容,每个内容请以分号隔开";
    _childNodeLab = childNodeLab;
    [self addSubview:_childNodeLab];

    NSButton *saveBtn = [NSButton buttonWithTitle:@"生成" target:self action:@selector(saveBtnClick)];
    _saveBtn = saveBtn;
    [self addSubview:_saveBtn];

    NSButton *clearBtn = [NSButton buttonWithTitle:@"清除" target:self action:@selector(clearBtnClick)];
    _clearBtn = clearBtn;
    [self addSubview:_clearBtn];

}


- (void)setupLayouts {
    CGFloat padding = 10.0f;
    [_childNodeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(padding);
        make.top.equalTo(self.mas_top).offset(padding);
        make.width.offset(300);
        make.height.offset(200);
    }];
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(padding);
        make.top.equalTo(_childNodeLab.mas_bottom).offset(padding);
        make.width.offset(300);
        make.height.offset(40);
    }];

    [_clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(padding);
        make.top.equalTo(_saveBtn.mas_bottom).offset(padding);
        make.width.offset(300);
        make.height.offset(40);
    }];
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(padding);
        make.top.equalTo(_childNodeLab.mas_bottom).offset(padding);
        make.width.offset(300);
        make.height.offset(40);
    }];

}

#pragma mark - delegate
- (void)saveBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(saveBtnAcion)]) {
        [self.delegate saveBtnAcion];
    }
}

- (void)clearBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clearBtnAcion)]) {
        [self.delegate clearBtnAcion];
    }
}

@end
