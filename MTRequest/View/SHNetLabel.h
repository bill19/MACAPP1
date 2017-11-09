//
//  SHNetLabel.h
//  MACAPP1
//
//  Created by HaoSun on 2017/11/8.
//  Copyright © 2017年 YHKIT. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#define SHNetLabelW 200.0f
#define SHNetLabelH 40.0f
@interface SHNetLabel : NSView

@property (nonatomic, weak) NSTextField *titleLab;
@property (nonatomic, weak) NSTextField *contentLab;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *content;
@end
