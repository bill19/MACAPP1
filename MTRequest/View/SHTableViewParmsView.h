//
//  SHTableViewParmsView.h
//  MACAPP1
//
//  Created by HaoSun on 2017/11/7.
//  Copyright © 2017年 YHKIT. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class SHParmsModel;
@class SHTableViewParmsView;
@protocol SHTableViewParmsViewDelegate <NSObject>

@optional
- (void)parmsViewClick:(SHParmsModel *)parmsModel ;
- (void)parmsViewClick:(SHParmsModel *)parmsModel parmsView:(SHTableViewParmsView *)parmsView;
@end


@interface SHTableViewParmsView : NSView


@property (nonatomic, weak) NSView *view;

@property (nonatomic, strong) NSArray *comboBoxItemArr;

@property (nonatomic, weak) NSTextField *urlText;

@property (nonatomic, weak) NSTextField *parameterText;

@property (nonatomic, weak) NSButton *btn;

@property (nonatomic, weak) id<SHTableViewParmsViewDelegate> delegate;

@property (nonatomic, strong) SHParmsModel *parmsModel;

@end
