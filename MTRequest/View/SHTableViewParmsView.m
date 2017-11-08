//
//  SHTableViewParmsView.m
//  MACAPP1
//
//  Created by HaoSun on 2017/11/7.
//  Copyright © 2017年 YHKIT. All rights reserved.
//

#import "SHTableViewParmsView.h"
#import "SHParmsModel.h"
#define KVIEWHALFHEIGHT 500.0f

@interface SHTableViewParmsView()<NSComboBoxDelegate,NSComboBoxDataSource>


@end
@implementation SHTableViewParmsView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {

    self.comboBoxItemArr = [NSArray arrayWithObjects:@"NSString",@"NSInteger",@"float",@"double",@"BOOL",@"NSDate", nil];

    NSView *view = [[NSView alloc] init];
    view.frame = CGRectMake(10, 0, KVIEWHALFHEIGHT, 80);
    [self addSubview:view];


    NSTextField *urlText = [[NSTextField alloc] init];
    urlText.frame = CGRectMake(0, 10, 100, 30);
    [view addSubview:urlText];

    NSComboBox *requestComBox = [[NSComboBox alloc]init];
    requestComBox.editable = NO;
    requestComBox.frame = CGRectMake(CGRectGetMaxX(urlText.frame)+10, 10, 80, 30);
    requestComBox.usesDataSource = true;
    requestComBox.delegate = self;
    requestComBox.dataSource = self;
    [requestComBox selectItemAtIndex:0];
    [view addSubview:requestComBox];

    NSTextField *parameterText = [[NSTextField alloc] init];
    parameterText.frame = CGRectMake(CGRectGetMaxX(requestComBox.frame)+10, 10, 150, 30);
    parameterText.placeholderString = @"请输入参数按照分号隔开";
    [view addSubview:parameterText];

    NSButton *btn = [NSButton buttonWithTitle:@"生成" target:self action:@selector(btnClick)];
    btn.frame = CGRectMake(CGRectGetMaxX(parameterText.frame)+10, 10, 100, 30);
//    [view addSubview:btn];

    _view = view;
    _urlText = urlText;
    _parameterText = parameterText;
    _btn = btn;

}


#pragma mark - NSComboBoxDelegate,NSComboBoxDataSource
- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)comboBox{
    return [_comboBoxItemArr count];
}
-(id)comboBox:(NSComboBox *)comboBox objectValueForItemAtIndex:(NSInteger)index{

    return _comboBoxItemArr[index];
}
-(void)comboBoxSelectionDidChange:(NSNotification *)notification{

}

#pragma mark -delegate
- (void)btnClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(parmsViewClick:)]) {
        [self.delegate parmsViewClick:_parmsModel];
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(parmsViewClick:parmsView:)]) {
        [self.delegate parmsViewClick:_parmsModel parmsView:self];
    }
}

- (void)setParmsModel:(SHParmsModel *)parmsModel {

    _parmsModel = parmsModel;
    _urlText.stringValue = parmsModel.netParameterName;

}

@end
