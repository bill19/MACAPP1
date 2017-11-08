//
//  SHChildNodeView.h
//  MACAPP1
//
//  Created by HaoSun on 2017/11/6.
//  Copyright © 2017年 YHKIT. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol SHChildNodeViewDelegate <NSObject>

@optional
- (void)saveBtnAcion;
- (void)clearBtnAcion;
@end

@interface SHChildNodeView : NSView

/**
 输入所有的路径 用分号隔开
 */
@property (nonatomic, weak) NSTextField *childNodeLab;

@property (nonatomic, weak) NSButton *saveBtn;

@property (nonatomic, weak) NSButton *clearBtn;
@property (nonatomic, weak) NSButton *openBtn;

@property (nonatomic, weak) id <SHChildNodeViewDelegate>delegate;

@end
