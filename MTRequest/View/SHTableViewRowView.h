//
//  SHTableViewRowView.h
//  MACAPP1
//
//  Created by HaoSun on 2017/11/7.
//  Copyright © 2017年 YHKIT. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class SHNetModel;
@class SHTableViewRowView;
@protocol SHTableViewRowViewDelegate <NSObject>
@optional

- (void)tableButtonClick:(SHNetModel *)model;

- (void)tableButtonClick:(SHNetModel *)model rowView:(SHTableViewRowView *)rowView;
@end


@interface SHTableViewRowView : NSView

@property (nonatomic, strong) SHNetModel *netModel;

@property (nonatomic, weak) id<SHTableViewRowViewDelegate> delegate;

@property (nonatomic, weak) NSView *view;

@property (nonatomic, strong) NSArray *comboBoxItemArr;

@property (nonatomic, weak) NSTextField *urlText;

@property (nonatomic, weak) NSTextField *parameterText;

@property (nonatomic, weak) NSComboBox *requestComBox;

@property (nonatomic, weak) NSButton *btn ;

@end
